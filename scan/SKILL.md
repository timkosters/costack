---
name: scan
description: Scan your world for changes — check configured sources, classify signals, update person and project pages
argument-hint: "[optional: 'quick' for abbreviated scan, or specific source name]"
---

# /scan — Context Scanner

Scan all configured sources for new information since the last scan. Classify what changed, update person and project pages, regenerate the context map.

## Step 0: Load Config

1. Read `~/.costack/config` for `NOTES_DIR` (where person/project pages live) and any source-specific settings.
2. Read `~/.costack/state/last-scan.md` for per-source timestamps showing when each source was last scanned.
3. If no state file exists, this is a first run — scan the last 24 hours as a default window.

## Step 1: Check Source Availability

CoStack adapts to whatever tools are available. Probe for each source category:

| Category | What to look for |
|----------|-----------------|
| **Email** | Any email MCP tool (search, list, read capabilities) |
| **Calendar** | Any calendar MCP tool (list events, find free time) |
| **Messaging** | Any chat/messaging MCP tool (list conversations, read messages) |
| **Meeting notes** | Any meeting notes MCP tool (list meetings, get transcripts) |
| **Task manager** | Any task/todo MCP tool (list tasks, find completed) |
| **CRM** | Any CRM MCP tool (search contacts, list records) |
| **Knowledge base** | Local notes directory (check via git log or file modification dates) |

For each category, record whether it's available or unavailable. **Skip unavailable sources gracefully** — never error out because a source is missing. Log which sources were skipped in the change summary.

If the argument is a specific source name (e.g., "email", "calendar"), scan only that source.

## Step 2: Scan Each Source

For each available source, pull new items since the last scan timestamp for that source.

### Messaging
- List active conversations / recent chats.
- For known contacts (people with pages in NOTES_DIR), read new messages since last scan.
- Fetch enough messages to capture full context (at least 50 per conversation — short replies can push substantive messages out of a small window).
- For each message thread, ask: "Does this change what CoStack knows about a person or project?"

### Email
- Start with metadata scan: subjects, senders, dates. This is cheap and fast.
- Selectively fetch full content only for substantive emails (skip newsletters, automated notifications, one-line acknowledgments).
- Flag emails that contain commitments, decisions, or requests.

### Calendar
- Look forward: today + tomorrow.
- Flag meetings that need preparation (especially first meetings with unfamiliar people).
- Note any recently added, moved, or cancelled events.

### Meeting Notes
- Fetch transcripts (raw text, not AI-generated summaries) from meetings since last scan.
- Extract: decisions made, action items assigned, commitments given, new people mentioned.
- Link findings to the relevant person and project pages.

### Task Manager
- Check active tasks for status changes.
- **Check recently completed tasks too** — avoid flagging done items as overdue later in /derive.
- Note any new tasks that appeared since last scan.

### CRM
- Check for recently modified contact records.
- Look for new interactions logged, deal stage changes, or notes added by others.

### Knowledge Base (Local Notes)
- Run `git log --since="<last_scan>" --name-only` in NOTES_DIR (if it's a git repo) to find changed files.
- Alternatively, check file modification dates.
- Scan changed files for new content relevant to tracked people or projects.

## Step 3: Classify Signals

Every new piece of information gets one classification:

| Classification | Meaning | Example |
|---------------|---------|---------|
| `status-update` | Something changed about a project | "We shipped the beta" |
| `relationship-update` | Something changed about a person or relationship | "They accepted a new role" |
| `commitment` | Someone committed to doing something | "I'll send the deck by Friday" |
| `completed` | Something was finished | A task marked done, a deliverable sent |
| `signal` | A subtle indicator worth noting but not actionable yet | Tone shift in messages, repeated mentions of a topic |
| `new-entity` | A person or initiative not currently tracked | New name in a meeting transcript |

For `new-entity` items: note them in the change summary but do NOT automatically create pages. The user decides who and what gets tracked.

## Step 4: Update Person Pages

For each tracked contact (person with a page in NOTES_DIR):

1. **Interaction history**: Append new interactions with date, channel, and brief summary.
2. **Understanding**: If something changes what CoStack knows about this person (new role, shifted priorities, new project involvement), update the understanding section.
3. **Commitments**: Log any new commitments (theirs to the user, or the user's to them) with dates if given.

Preserve existing content. Append, don't overwrite. Use the page format established in NOTES_DIR.

## Step 5: Update Project Pages

For each tracked project (project page in NOTES_DIR):

1. **Status**: Update if a meaningful change occurred.
2. **Work log**: Add dated entries for significant events.
3. **Tasks/blockers**: Note any new tasks surfaced or blockers resolved.
4. **People**: If a new person became involved, add them to the project's people list.

## Step 6: Regenerate Context Map

Overwrite `~/.costack/context-map.md` with a fresh snapshot of current state:

- Active projects with one-line status each
- People with pending commitments or recent activity
- Items needing attention (upcoming deadlines, unanswered questions, stale threads)

**Audit old entries**: Drop signals older than 14 days that were never acted on. Remove "needs response" flags if a response was found in fresh data. Never carry forward stale urgency without re-verifying against fresh data.

## Step 7: Produce Change Summary

Output a structured summary of what changed during this scan:

```
## Scan Summary — YYYY-MM-DD HH:MM

### Sources Scanned
- [list of sources checked, with item counts]

### Sources Skipped
- [list of unavailable sources]

### Signals
- [classified list of everything found, grouped by type]

### Pages Updated
- People: [list]
- Projects: [list]

### Needs Attention
- [anything that warrants the user's input — new entities to decide on, ambiguous signals]
```

If argument was `quick`: abbreviate the summary to just Signals and Needs Attention.

## Step 8: Update State

Write per-source timestamps to `~/.costack/state/last-scan.md`:

```
## Last Scan Timestamps
- email: 2024-01-15T14:30:00
- calendar: 2024-01-15T14:30:00
- messaging: 2024-01-15T14:31:00
...
```

## Safety Constraints

- **NEVER send messages** on any platform. Read only.
- **NEVER delete data** in any system.
- **Notes directory is the only write target** (plus CoStack's own state files).
- Skip unavailable sources gracefully — log what was skipped, never error out.
- If a source is responding slowly or timing out, note it and move on.
