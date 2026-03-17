---
name: health
description: System diagnostic — check file integrity, context freshness, memory health, and configuration
argument-hint: ""
---

# Health Check

Run a diagnostic sweep across CoStack's configuration and state. Purely diagnostic — never auto-fixes anything.

## Instructions

Run each check below. For each, report status as **OK**, **WARNING**, or **ERROR**.

### 1. Config Check
- Does `~/.costack/config` exist?
- Is `NOTES_DIR` set and does the directory exist?
- Are any required config values missing?

### 2. Memory Check
- Does `MEMORY.md` exist in `~/.costack/memory/`?
- Is it under 200 lines? (WARNING if over)
- Are there topic files referenced in the index but missing from disk?
- Are there topic files on disk but not referenced in the index?

### 3. State Check
- Read `~/.costack/state/last-scan.md`
- When was the last `/context-collect`? If more than 48 hours ago, WARNING.
- Are any source timestamps missing?

### 4. CLAUDE.md Check
- Does `~/.claude/CLAUDE.md` exist?
- Is it under 200 lines? (WARNING if over, with current line count)

### 5. Skills Check
- For each CoStack skill directory, verify `SKILL.md` exists
- List any skills that are missing their definition file

### 6. Notes Check
- If `NOTES_DIR` is configured, check:
  - Are there person pages (files with `type: person` in frontmatter)?
  - Are there project pages (files with `type: project` in frontmatter)?
  - Does a context map exist?
  - Are there daily notes?
- Report counts for each

### 7. Diary Check
- How many unprocessed diary entries exist in `~/.costack/memory/diary/`?
- When was the last `/reflect`? Check `~/.costack/memory/reflections/` for the most recent file.

### 8. Freshness Check
- Flag any context files (context map, person pages, project pages) not updated in the last 7 days
- Check `last-context-update` frontmatter on person pages
- Check modification dates on project pages

## Output Format

```
CoStack Health Check — [date]

Config ........... [OK/WARNING/ERROR] [details]
Memory ........... [OK/WARNING/ERROR] [details]
State ............ [OK/WARNING/ERROR] [details]
CLAUDE.md ........ [OK/WARNING/ERROR] [details]
Skills ........... [OK/WARNING/ERROR] [details]
Notes ............ [OK/WARNING/ERROR] [details]
Diary ............ [OK/WARNING/ERROR] [details]
Freshness ........ [OK/WARNING/ERROR] [details]

[Any actionable suggestions, grouped by priority]
```
