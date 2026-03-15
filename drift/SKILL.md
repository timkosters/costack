---
name: drift
description: Compare stated intentions vs actual behavior — find what's being avoided, what's unplanned, and follow-through patterns
argument-hint: "[optional: number of days to analyze, default 14]"
---

# Drift Analysis

Compare what was intended against what actually happened. Surface avoidance patterns, unplanned wins, and follow-through rates.

## Setup

Read `~/.costack/config` for `NOTES_DIR`. Daily notes should be in a subfolder (e.g., `NOTES_DIR/Daily/` or `NOTES_DIR/journals/`). Detect the convention by listing folders in NOTES_DIR.

## Input

- Optional argument: number of days to analyze (default: 14)

## Stage 1: Gather Intentions

Read the last N days of daily notes from NOTES_DIR. Extract every stated intention — phrases like "my goal today", "I need to", "I'm going to", "priority for today", "plan to", "want to", "should", "will focus on".

For each intention, record:
- **Date** it was stated
- **Exact quote** (preserve original wording)
- **Category**: concrete task, behavioral goal, strategic intention, or meta-goal

Search daily notes using grep or semantic search. Cast a wide net — intentions hide in different phrasings.

## Stage 2: Gather Actions

Collect evidence of what actually happened:
- Task manager: check completed items for the period (use both active and completed task queries)
- Calendar: events attended during the period
- Project pages: work log entries, recent edits
- Daily notes: completed checkboxes, "done" or "finished" mentions, work summaries

## Stage 3: Compare and Categorize

Match intentions against actions. Place each intention into exactly one bucket:

1. **Followed Through** — Intention stated AND corresponding action taken. Note the lag time (same day, next day, delayed).
2. **Dropped** — Stated once, no evidence of action. Low signal — could be a passing thought.
3. **Avoided** — Stated 2+ times across different days, no action found. This is the most important category. Something is blocking progress.
4. **Completed via Different Path** — The outcome was achieved, but through different means than originally intended.
5. **Unplanned Wins** — Significant work completed that was never mentioned in any intention. Reveals actual priorities vs stated priorities.
6. **Priority Shifts** — Explicitly superseded by a new priority (look for "actually, I'll do X instead" or "this is more important now"). This is healthy adaptation, not avoidance.

## Stage 4: Pattern Analysis

Calculate and assess:
- **Follow-through rate**: (followed through + different path) / total intentions
- **Avoidance patterns by type**: Are behavioral goals avoided more than concrete tasks? Strategic intentions more than meta-goals?
- **Self-awareness accuracy**: How well do stated priorities match where time actually went?
- **Unplanned work ratio**: What fraction of completed work was never planned?
- **Time-of-week patterns**: Are certain days more productive or more prone to drift?

## Stage 5: Write Output

Append a section to today's daily note in NOTES_DIR under `### Drift Analysis (N days)`:

```
> [!info]- Drift Analysis — [date range]
> **Follow-through rate**: X/Y (Z%)
>
> **Followed Through**
> - [item] (stated [date], completed [date])
>
> **Avoided** (stated 2+ times, no action)
> - [item] — stated [dates]. [Brief observation about why this might be stuck.]
>
> **Unplanned Wins**
> - [item] — not in any intention but significant work done
>
> **The Drift**
> [2-3 sentence summary of the gap between intentions and reality. What does the pattern say about actual vs stated priorities?]
>
> **Nudge**
> [One specific, actionable suggestion about the biggest avoidance pattern. Not generic advice — reference the specific item and suggest a concrete next step.]
```

## Rules

- **Tone is accountability buddy, not judge.** Observations, not accusations. "This has come up 4 times without progress" not "You keep failing to do this."
- **Quote specific intentions with dates.** Every claim must be traceable.
- **Avoidance requires 2+ mentions.** A single dropped intention is noise. Repeated drops are signal.
- **Distinguish priority shifts from avoidance.** If the user explicitly deprioritized something, that goes in Priority Shifts, not Avoided.
- **The "gentle nudge" must be specific and actionable.** Not "consider making time for X" but "the smallest version of X would be [concrete step] — could that happen tomorrow?"
- **Don't moralize about unplanned work.** Unplanned wins often reveal what someone actually cares about. Frame them as useful signal, not deviation.
- **If follow-through rate is high, say so.** This skill should feel rewarding when things are going well, not only surface problems.
