---
name: derive
description: Reason about what changes imply — find gaps, timeline risks, priority shifts, patterns, and commitment tracking
argument-hint: "[optional: 'weekly' for weekly commitment check mode]"
---

# /derive — Reasoning Engine

Take the current state of the world (context map, project pages, person pages, recent scan results) and reason about what it implies. Surface insights that aren't obvious from any single source.

## Setup

Read `~/.costack/config` for `NOTES_DIR`.

## Input

1. **Context Map**: `~/.costack/context-map.md` — current snapshot of active projects, people, and signals.
2. **Active project pages** in NOTES_DIR — read all pages tagged as active projects.
3. **Person pages** in NOTES_DIR — read pages for people involved in active work.
4. **Recent scan summary** — if /scan was just run, use its output. Otherwise, read the context map as the baseline.

If argument is `weekly`: run all five reasoning patterns with extra emphasis on Follow-Through Tracking (commitment check mode).

## Five Reasoning Patterns

Run each pattern in sequence. Not every pattern will produce output every time — that's fine.

### 1. Gap Detection

For each active project, check three types of gaps:

- **People gaps**: Is anyone needed who isn't involved yet? Is a key person overloaded or disengaged?
- **Deliverable gaps**: Are there expected outputs with no one working on them?
- **Prerequisite gaps**: Does this project depend on something that hasn't happened yet? Is anyone waiting on something that no one is actively producing?

Flag gaps only when they're actionable. "We might eventually need a designer" is not a gap. "The deck is due Friday and no one has started it" is.

### 2. Timeline Inference

For projects with deadlines (explicit or implied):

- Work backwards from the deadline. Given current pace and remaining work, will it be done?
- Factor in known blockers, upcoming holidays, people's other commitments.
- If the math doesn't work, say so plainly: "At current pace, Project X will miss its deadline by ~N days."

Don't invent deadlines. If a project has no deadline, skip it for this pattern.

### 3. Priority Shift Impact

When someone's bandwidth or focus changes (new project, travel, role change, illness), trace the impact:

- What were they responsible for?
- Who else is affected?
- Which projects slow down or stall?

This pattern often produces the most surprising insights — a single person's schedule change can cascade across multiple projects.

### 4. Pattern Recognition

Look across all sources for convergence:

- **Topic convergence**: Are separate conversations touching the same topic? (Two people independently mentioning the same concern is a signal.)
- **People convergence**: Are unconnected people working on related things without knowing it? Could an introduction help?
- **Timing convergence**: Are multiple things coming to a head in the same week? Is there a bottleneck forming?

Be specific. "There's a lot happening" is not a pattern. "Three different people mentioned budget concerns this week, and the budget review is next Thursday" is.

### 5. Follow-Through Tracking

For every commitment found in recent scans (and still open from previous scans):

- **Was it done?** Check task manager completions, email sends, messages sent.
- **Is it overdue?** If past the stated or implied deadline, flag it.
- **Is it at risk?** If the deadline is approaching and no progress is visible, flag it.

Track commitments in both directions: things the user promised others, and things others promised the user.

In `weekly` mode: do a comprehensive sweep of ALL open commitments, not just recent ones. This is the weekly accountability check.

## Output

### To Project Pages
Add tagged entries for actionable findings:

- Gaps flagged as open questions or blockers
- Timeline warnings added to the status section
- New tasks surfaced from commitment tracking

### To Task Manager (Sparse)
Create at most **1-3 tasks per run**. Only for items that are:
- Time-sensitive (deadline within 7 days)
- At risk of being forgotten
- Not already tracked somewhere

If nothing qualifies, create zero tasks. Restraint is a feature.

### To Daily Note (or Change Summary)
A brief changelog entry:

```
### CoStack Derive — HH:MM
- [2-3 key insights, one line each]
- [any items flagged for user attention]
```

### To the User
Present 2-3 key insights conversationally. Then ask:

> "Anything here that needs deeper attention?"

This gives the user a chance to steer before CoStack moves on.

## Safety Constraints

- **Read-heavy, write-light.** Most of the work is reading and reasoning. Writes go only to: notes directory, task manager (sparse), CoStack state files.
- **Tone is neutral observation, not judgment.** "This commitment is 3 days overdue" — not "You dropped the ball on this."
- **Never send messages.** If an insight implies the user should message someone, say so — don't do it.
- **Never inflate urgency.** If something is fine, don't manufacture concern. Silence from /derive is a good sign.
- **Verify before flagging.** Before saying something is overdue or missing, check completed tasks and recent messages. Stale flags erode trust fast.
