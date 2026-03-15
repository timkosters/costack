---
name: reflect
description: Analyze session patterns and diary entries — identify recurring preferences, mistakes, and propose CLAUDE.md improvements
argument-hint: "[optional: 'diary' to just capture current session, or 'last N entries' to analyze]"
---

# Reflect

Two modes: capture a session diary entry, or analyze diary entries to improve CLAUDE.md.

## Input

- No argument or `diary`: capture current session as a diary entry
- `last N` or a number: analyze the last N diary entries for patterns

## Mode 1: Diary

Capture learnings from the current session.

### Steps

1. Review the current conversation from start to finish.
2. Create a structured diary entry:

```markdown
---
date: YYYY-MM-DD
session: N
---

## Task
[One-line summary of what was requested]

## Work Summary
[2-3 sentences on what was done]

## Design Decisions
- [Key choices made and why]

## Challenges
- [What was hard, what failed, what took multiple attempts]

## Solutions
- [How challenges were resolved]

## User Preferences Observed
- [Any explicit or implicit preferences: formatting, tone, tool choices, workflow patterns]

## Mistakes
- [Anything that went wrong or had to be corrected]
```

3. Save to `~/.costack/memory/diary/YYYY-MM-DD-session-N.md`. Determine N by counting existing entries for today's date.
4. Create the directory if it doesn't exist.

## Mode 2: Reflect

Analyze diary entries for patterns and update CLAUDE.md.

### Steps

1. **Read diary entries** from `~/.costack/memory/diary/`. Read the number requested (default: all unprocessed).
2. **Check processed log** at `~/.costack/memory/reflections/processed.log` to identify which entries have already been analyzed. Skip those unless re-analysis is explicitly requested.
3. **Analyze for patterns** across entries, in strict priority order:

   **Priority 1 — Rule Violations**: Existing CLAUDE.md rules that were broken during sessions. These need strengthening. The fix goes at the source: find the original rule and rewrite it to be clearer, not add a second rule.

   **Priority 2 — Persistent Preferences**: Behaviors or preferences observed 2+ times across different sessions. These are candidates for new CLAUDE.md rules.

   **Priority 3 — Anti-patterns**: Recurring mistakes or approaches that consistently fail. Add as explicit "do not" rules.

   **Priority 4 — Pruning Candidates**: Rules currently in CLAUDE.md that have no supporting evidence in any diary entry. These may be dead weight. Propose removal but never auto-remove.

4. **Write reflection document** to `~/.costack/memory/reflections/YYYY-MM-DD.md`:

```markdown
---
date: YYYY-MM-DD
entries_analyzed: [list of filenames]
---

## Findings

### Rule Violations (Priority 1)
- [Rule]: violated in [entry]. Proposed fix: [rewrite]

### New Patterns (Priority 2)
- [Pattern]: observed in [entries]. Proposed rule: [one-line rule]

### Anti-patterns (Priority 3)
- [Anti-pattern]: observed in [entries]. Proposed rule: [one-line rule]

### Pruning Candidates (Priority 4)
- [Rule]: no evidence of use across N entries. Recommend: [keep/remove/merge]

## CLAUDE.md Changes
[Exact diff of what was changed]
```

5. **Update CLAUDE.md** — apply Priority 1 and Priority 2 changes. Show the user exactly what changed.
6. **Update processed log** — append analyzed entry filenames to `~/.costack/memory/reflections/processed.log`.
7. Create directories if they don't exist.

## Principles

- **Fix at the source.** When a rule was violated, the original instruction is unclear. Rewrite it. Do not add a compensating rule alongside the broken one — that creates contradictions.
- **Rules must be succinct.** One line, imperative tone, actionable. "Use X for Y" not "When doing Y, it is generally recommended to consider using X."
- **Frequency matters.** 2+ occurrences = pattern. 3+ = strong pattern. 1 occurrence = anecdote (note it but don't codify).
- **Show what changed.** Always display the before/after of any CLAUDE.md modification so the user can approve or revert.
- **Pruning is proposal-only.** Never delete rules without explicit user approval. Flag them, present evidence (or lack thereof), let the user decide.
- **Contradictions are bugs.** If a new rule would contradict an existing one, resolve the contradiction by rewriting one or both. Never leave two contradictory rules in place.
