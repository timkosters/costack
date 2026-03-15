---
name: deep-reflect
description: Search old notes for connections to current themes — surface patterns, recurring ideas, and non-obvious links between people
argument-hint: "[optional: specific theme to focus on]"
---

# Deep Reflect

Weekly vault reflection. Searches old notes for connections to what's currently top of mind. Surfaces forgotten ideas, recurring patterns, and non-obvious links between people.

## Input

- No argument: automatically extract themes from recent context
- A quoted theme: focus the search on that specific topic (e.g., `"community governance"`)

## Setup

Read `~/.costack/config` for `NOTES_DIR`. The context map is at `~/.costack/context-map.md`. Daily notes should be in a subfolder of NOTES_DIR (e.g., `Daily/` or `journals/`). Detect the convention by listing folders.

## Stage 1: Surface Current Themes

If no theme argument was provided:

1. Read the context map at `~/.costack/context-map.md` and the last 7 days of daily notes from NOTES_DIR.
2. Extract 3-5 **themes** — not tasks, not to-do items, but recurring topics, concerns, or strategic directions. Examples: "decentralized governance", "creative energy management", "building in public", "trust in small groups".
3. If a specific theme was provided as argument, use that as the sole theme (or primary theme plus 1-2 related ones).

## Stage 2: Deep Search

For each theme:

1. Search the notes directory using grep with multiple keyword variations (or semantic search if a vector search tool is configured).
2. **Target OLD notes** — prioritize results from 30+ days ago. Recent notes are already top of mind; the value is in forgotten connections.
3. Run 2-3 searches per theme with different angles:
   - Direct keyword match
   - Synonym or adjacent concept
   - People or projects associated with the theme
4. Collect matching notes with their dates and relevant excerpts.

## Stage 3: Generate Insights

Produce three types of insight:

### Connections
Link a current theme to a specific old note. Format:
> Current theme **[X]** connects to **[note title]** from [date]: "[relevant excerpt]". The connection is [why this is relevant now].

Every connection MUST reference a specific note by name and date.

### Patterns
Recurring themes across multiple time periods. Format:
> **[Pattern name]**: This idea first appeared in [note, date], resurfaced in [note, date], and is now present in [current context]. The evolution: [how thinking has changed or stayed the same].

Patterns MUST cite at least 3 data points across different time periods.

### People Bridges
Non-obvious connections between people from different contexts. Format:
> **[Person A]** and **[Person B]** share an interest in [topic] — A wrote about it in [note, date], B came up in [note, date] in the context of [context]. They may not know each other but could have a valuable conversation about [specific topic].

People bridges must be **genuinely non-obvious**. If two people already work together or are in the same organization, that's not a bridge. The value is in connecting people who wouldn't naturally find each other.

## Stage 4: Write Output

Append to today's daily note in NOTES_DIR:

```markdown
### Deep Reflect

> [!info]- Vault Reflection — [date]
> **Themes explored**: [list]
>
> **Connections**
> - [connection 1]
> - [connection 2]
>
> **Patterns**
> - [pattern 1]
>
> **People Bridges**
> - [bridge 1]
>
> **Notes Worth Revisiting**
> - [[Note Name]] — [one-line reason to re-read it]
```

## Quality Checks

- Every connection references a specific note with its date. No vague "you once wrote about X."
- Patterns cite multiple data points. A single old mention is a connection, not a pattern.
- People bridges are non-obvious. If the connection is already well-known, skip it.
- At least half the referenced notes should be 60+ days old. The whole point is surfacing forgotten material.
- **If nothing interesting surfaces for a theme, say so.** "No meaningful connections found for [theme]" is better than forcing a weak insight.
- Do not fabricate connections. If the search doesn't find relevant old notes, report that honestly.
