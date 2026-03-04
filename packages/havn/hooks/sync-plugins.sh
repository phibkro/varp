#!/usr/bin/env bash
# sync-plugins.sh — Detect project dependencies and enable matching Claude Code plugins.
# Runs as a SessionEnd hook. Merges only enabledPlugins; preserves all other settings.
# Writes to settings.local.json (gitignored, per-machine) to avoid noisy diffs.
# Exit 0 always — never break session end.

main() {
  # --- Locate project root (git root or CWD from stdin) ---
  local project_root=""
  if git_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
    project_root="$git_root"
  else
    # Fall back to cwd from hook input (stdin is JSON with a cwd field)
    local input
    input="$(cat)"
    if command -v jq >/dev/null 2>&1; then
      project_root="$(printf '%s' "$input" | jq -r '.cwd // empty')"
    fi
  fi

  if [[ -z "$project_root" || ! -d "$project_root" ]]; then
    echo >&2 "sync-plugins: could not determine project root, skipping"
    return 0
  fi

  # --- Require jq ---
  if ! command -v jq >/dev/null 2>&1; then
    echo >&2 "sync-plugins: jq not found, skipping"
    return 0
  fi

  # --- Collect all package.json dependency names ---
  local all_deps=""

  read_deps_from() {
    local pkg="$1"
    if [[ -f "$pkg" ]]; then
      # Extract keys from dependencies, devDependencies, peerDependencies
      all_deps="$all_deps $(jq -r '
        (.dependencies // {} | keys[]),
        (.devDependencies // {} | keys[]),
        (.peerDependencies // {} | keys[])
      ' "$pkg" 2>/dev/null || true)"
    fi
  }

  # Root package.json
  read_deps_from "$project_root/package.json"

  # Monorepo workspace packages (packages/*/package.json)
  local pkg
  for pkg in "$project_root"/packages/*/package.json; do
    [[ -f "$pkg" ]] && read_deps_from "$pkg"
  done

  # --- Detect which plugins to enable ---
  local plugins_to_enable=()

  # effect → effect-ts@effect-ts
  if printf '%s' "$all_deps" | grep -qw "effect"; then
    plugins_to_enable+=("effect-ts@effect-ts")
  fi

  # next or react → frontend-design@claude-plugins-official
  if printf '%s' "$all_deps" | grep -qwE "next|react"; then
    plugins_to_enable+=("frontend-design@claude-plugins-official")
  fi

  # .claude-plugin/plugin.json anywhere in tree → plugin-dev@claude-plugins-official
  if find "$project_root" -maxdepth 4 \
      -not -path '*/node_modules/*' \
      -not -path '*/.git/*' \
      -path '*/.claude-plugin/plugin.json' \
      -print -quit 2>/dev/null | grep -q .; then
    plugins_to_enable+=("plugin-dev@claude-plugins-official")
  fi

  if [[ ${#plugins_to_enable[@]} -eq 0 ]]; then
    echo >&2 "sync-plugins: no matching dependencies detected, nothing to do"
    return 0
  fi

  # --- Build the enabledPlugins JSON object ---
  local plugins_json="{}"
  local plugin
  for plugin in "${plugins_to_enable[@]}"; do
    plugins_json="$(printf '%s' "$plugins_json" | jq --arg p "$plugin" '. + {($p): true}')"
  done

  # --- Merge into .claude/settings.local.json (gitignored, per-machine) ---
  local settings_dir="$project_root/.claude"
  local settings_file="$settings_dir/settings.local.json"
  local tmp_file="$settings_file.tmp"

  mkdir -p "$settings_dir"

  local existing="{}"
  if [[ -f "$settings_file" ]]; then
    existing="$(cat "$settings_file")"
  fi

  # Deep-merge: existing enabledPlugins + new detections (new wins on conflict),
  # then merge that back into the full settings object.
  local updated
  updated="$(printf '%s' "$existing" | jq --argjson new "$plugins_json" '
    .enabledPlugins = ((.enabledPlugins // {}) * $new)
  ')"

  # Atomic write: write to temp, then rename
  printf '%s\n' "$updated" > "$tmp_file" && mv "$tmp_file" "$settings_file"

  # --- Report ---
  echo >&2 "sync-plugins: enabled ${plugins_to_enable[*]} in $settings_file"
}

main "$@" || true
exit 0
