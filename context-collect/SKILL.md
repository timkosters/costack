---
name: context-collect
description: Collect context from every connected source — full sweep or focused on a specific person, project, or topic
argument-hint: "[optional: person name, project name, or topic to focus on]"
---

# /context-collect — Gather Context From Everywhere

Two modes:
- **No argument**: Full sweep across all sources. Update everything. Regenerate the context map.
- **With a topic**: Focused collection. Search every source for everything related to one person, project, or theme. Assemble it into a single page.

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

For each category, record whether it's available or unavailable. **Skip unavailable sources gracefully** — never error out because a source is missing.

---

## Mode A: Full Sweep (no argument)

Scan all sources for new information since the last scan. Classify, update pages, regenerate context map.

### Scan Each Source

For each available source, pull new items since the last scan timestamp.

**Messaging**
- List active conversations / recent chats.
- For known contacts (people with pages in NOTES_DIR), read new messages since last scan.
- Fetch enough messages to capture full context (at least 50 per conversation — short replies can push substantive messages out of a small window).
- For each thread: "Does this change what CoStack knows about a person or project?"

**Email**
- Start with metadata scan: subjects, senders, dates. This is cheap and fast.
- Selectively fetch full content only for substantive emails (skip newsletters, automated notifications, one-line acknowledgments).
- Flag emails that contain commitments, decisions, or requests.

**Calendar**
- Look forward: today + tomorrow.
- Flag meetings that need preparation (especially first meetings with unfamiliar people).
- Note any recently added, moved, or cancelled events.

**Meeting Notes**
- Fetch transcripts (raw text, not AI-generated summaries) from meetings since last scan.
- Extract: decisions made, action items assigned, commitments given, new people mentioned.
- Link findings to the relevant person and project pages.

**Task Manager**
- Check active tasks for status changes.
- **Check recently completed tasks too** — avoid flagging done items as overdue later in /derive.
- Note any new tasks that appeared since last scan.

**CRM**
- Check for recently modified contact records.
- Look for new interactions logged, deal stage changes, or notes added by others.

**Knowledge Base (Local Notes)**
- Run `git log --since="<last_scan>" --name-only` in NOTES_DIR (if it's a git repo) to find changed files.
- Alternatively, check file modification dates.
- Scan changed files for new content relevant to tracked people or projects.

### Classify Signals

Every new piece of information gets one classification:

| Classification | Meaning | Example |
|---------------|---------|---------|
| `status-update` | Something changed about a project | "We shipped the beta" |
| `relationship-update` | Something changed about a person or relationship | "They accepted a new role" |
| `commitment` | Someone committed to doing something | "I'll send the deck by Friday" |
| `completed` | Something was finished | A task marked done, a deliverable sent |
| `signal` | A subtle indicator worth noting but not actionable yet | Tone shift in messages, repeated mentions |
| `new-entity` | A person or initiative not currently tracked | New name in a meeting transcript |

For `new-entity` items: note them in the change summary but do NOT automatically create pages.

### Update Person Pages

For each tracked contact (person with a page in NOTES_DIR):
1. **Interaction history**: Append new interactions with date, channel, and brief summary.
2. **Understanding**: If something changes what CoStack knows about this person, update the understanding section.
3. **Commitments**: Log any new commitments with dates if given.

Preserve existing content. Append, don't overwrite.

### Update Project Pages

For each tracked project:
1. **Status**: Update if a meaningful change occurred.
2. **Work log**: Add dated entries for significant events.
3. **Tasks/blockers**: Note new tasks or resolved blockers.
4. **People**: If a new person became involved, add them.

### Regenerate Context Map

Overwrite `~/.costack/context-map.md` with a fresh snapshot:
- Active projects with one-line status each
- People with pending commitments or recent activity
- Items needing attention (upcoming deadlines, unanswered questions, stale threads)

**Audit old entries**: Drop signals older than 14 days that were never acted on. Remove "needs response" flags if a response was found. Never carry forward stale urgency without re-verifying.

### Change Summary

Output a structured summary:

```
## Context Collect — YYYY-MM-DD HH:MM

### Sources Checked
- [list with item counts]

### Sources Skipped
- [unavailable sources]

### What Changed
- [classified signals, grouped by type]

### Pages Updated
- People: [list]
- Projects: [list]

### Needs Attention
- [things that need the user's input]
```

### Update State

Write per-source timestamps to `~/.costack/state/last-scan.md`.

---

## Mode B: Focused Collection (with topic argument)

The user gave a person name, project name, or topic. Search EVERY available source for anything related, and assemble it into one page.

### Identify the Target

Determine whether the argument is:
- **A person** — check if they have an existing page in NOTES_DIR
- **A project** — check if it has an existing page in NOTES_DIR
- **A topic/theme** — freeform search term

### Search Every Source

For each available source, search for the target:

- **Email**: Search by name, email address, subject keywords
- **Calendar**: Search for events with this person/topic
- **Messaging**: Search conversations for mentions, or find the direct conversation with this person
- **Meeting notes**: Search transcripts for mentions
- **Task manager**: Search tasks mentioning this person/project
- **CRM**: Search records for this person/company
- **Knowledge base**: Search notes for mentions, backlinks, tags

Cast a wide net. Better to include something tangential than miss something important.

### Assemble the Page

Create a single page in NOTES_DIR that brings everything together:

```markdown
# Context: [Topic/Person/Project Name]

*Collected YYYY-MM-DD HH:MM from [N] sources*

## Summary
[2-3 sentence overview of what was found]

## Timeline
[Chronological list of all interactions, events, and mentions — most recent first]
- YYYY-MM-DD | [source] | [what happened]
- YYYY-MM-DD | [source] | [what happened]

## Key Details
[Extracted facts: commitments, decisions, open questions, deadlines]

## Open Threads
[Things that are unresolved or need follow-up]

## Raw Sources
[Links or references to original items so the user can dig deeper]
```

If the person/project already has a page, **update it** rather than creating a duplicate. Add the collected context as a new dated section.

### Present Results

Show the user what was found, organized by recency and importance. Highlight:
- Most recent interaction
- Any unresolved commitments (theirs or yours)
- Upcoming events or deadlines
- Anything that seems time-sensitive

---

## Safety Constraints

- **NEVER send messages** on any platform. Read only.
- **NEVER delete data** in any system.
- **Notes directory is the only write target** (plus CoStack's own state files).
- Skip unavailable sources gracefully — log what was skipped, never error out.
- If a source is responding slowly or timing out, note it and move on.
