---
name: prompt-writing
description: Use when writing or editing CLAUDE.md rules, agent frontmatter, hook prompts, skill procedures, or any text intended to control AI agent behavior. Triggers on "write a rule", "add to CLAUDE.md", "agent instruction", "system prompt", "rule not followed", "agent ignores instruction".
---

# Prompt Writing

**Optimize for**: compliance > context efficiency. Both matter; compliance wins ties.

## The Three-Part Rule

Every effective rule answers exactly three questions:

1. **What exactly?** Name the mechanism — parameter, tool, identifier, exact value. `run_in_background: true` not "run in background."
2. **What failure does this prevent?** Name what the agent will do wrong without the rule. If you can't name the failure, the rule may be unnecessary.
3. **What instead?** Prohibitions without alternatives get worked around. State the replacement behavior.

If any part is missing, the rule has a hole.

## Encoding Format

Choose based on the rule's nature:

| When | Format | Why |
|---|---|---|
| Clear, no edge cases | Direct statement | Lowest token cost, highest compliance |
| Ordering matters | Numbered steps | Agents derive wrong sequences from principles |
| Context-dependent judgment | Socratic question | Agent applies the question to its situation and derives correct behavior |

**Default to principles.** Escalate to procedures when you observe agents deriving the wrong sequence from the principle. If the same misordering recurs after one rewrite of the principle, the ordering is inherently non-obvious — encode it as a procedure.

### Direct statement
```
Agent and Bash: always `run_in_background: true`. Never call TaskOutput to block — completion notifications arrive automatically.
```
One sentence per rule. If it needs two, the second closes a loophole or names the mechanism.

### Procedure (when ordering matters)
```
1. Run tests  2. Read output  3. Only then commit
```
Use only when misordering causes real harm.

### Socratic question (context-dependent)
```
Before abstracting: can I point to two call sites that need this? If not, inline it.
```
Encodes the principle AND the edge cases. The agent reasons about its current context rather than pattern-matching a static rule. Use when the correct behavior depends on circumstances.

## Before writing, ask:

- **Adversarial reading test**: Read the rule as a literal-minded agent would. If the text permits a behavior that violates your intent, it will happen. Tighten until literal and intended readings converge.
- **Single concern**: Does this rule bundle two concerns? Split them. Agents follow atomic rules better than compound ones.
- **Motivation check**: Am I explaining *why*? Cut it unless the why prevents misapplication. Agents need compliance targets, not motivation.
- **Identifier over description**: Can I use an exact identifier (`run_in_background: true`) instead of a description ("run things in the background")? Identifiers are unambiguous and usually shorter.
- **Is this a principle or a procedure?** If the agent needs to reason about context, encode as a Socratic question. If it just needs to do the thing, direct statement.
