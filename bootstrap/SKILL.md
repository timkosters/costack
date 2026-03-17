---
name: bootstrap
description: First-run setup — configure CoStack and build its understanding of your world through a structured conversation
argument-hint: ""
---

# /bootstrap — Setup & Interview

The complete onboarding experience. Configures CoStack, interviews you about your world, and sets everything up so /scan and /derive work from day one.

## Before Starting

1. Check if `~/.costack/` exists. If not, tell the user:
   > "Looks like you haven't run the install script yet. Paste this into your terminal:
   > `git clone https://github.com/timkosters/costack.git ~/.claude/skills/costack && cd ~/.claude/skills/costack && ./setup.sh`
   > Then come back and type /bootstrap again."
2. Read `~/.costack/config`. If `NOTES_DIR` is empty, we'll set it up in Step 1.
3. Check if any person or project pages already exist in NOTES_DIR. If so, read them — don't ask the user to repeat what CoStack already knows.

## Step 1: Quick Setup (~2 min)

Start with a brief, friendly orientation:

> "Hey! I'm going to get CoStack set up for you. This takes about 20 minutes — I'll ask about your work, your team, and your tools, and build your context as we go. Let's start with a few quick setup questions."

### Notes directory

If NOTES_DIR is empty in `~/.costack/config`:

> "CoStack keeps track of your world using markdown files — pages for people, projects, and a context map. Where should I put these?
>
> If you use Obsidian, Logseq, or any markdown notes app, point me at that folder. If not, I'll create a `~/costack-notes/` folder for you."

Accept the path. Validate it exists (or create it). Write it to `~/.costack/config`.

### What you do

> "What's your role? Just a quick one-liner — something like 'I run ops at a startup' or 'I'm a researcher managing 5 projects.'"

### Where you're based

> "Where are you based? (This helps me understand your timezone for scheduling context.)"

Store these answers — they'll go into the CLAUDE.md at the end.

## Step 2: Your Team (~5-10 min)

> "Great. Let's talk about the people you work with. Start with whoever comes to mind — your closest collaborators, your team, anyone you interact with regularly."

For each person:
- **Name and role** — what do they do?
- **Current focus** — what are they working on right now?
- **Working relationship** — how do you interact? What do you need from them?
- **Communication** — where do you usually talk to them?

Prompt naturally. Don't force a rigid format — let the user describe people however they want, and extract the structure yourself.

After each person is described, **immediately create their person page** in NOTES_DIR. Don't wait until the end. Show the user what you created.

When the user runs out of names, move on. Don't push for completeness — /scan will add people over time.

## Step 3: Key Collaborators (~5-10 min)

> "Now — anyone outside your core team who matters? Partners, clients, advisors, investors, collaborators..."

For each:
- **Who are they?** Name, organization, role.
- **Current state** — active project together? Dormant? Exploratory?
- **Open asks** — anything pending between you?

Create pages as you go. Link to team members from Step 2 where relevant.

## Step 4: Projects (~5-10 min)

> "Let's map out what you're working on. What are your active projects right now?"

For each project:
- **One-line description** — what is it?
- **Status** — where does it stand?
- **What's blocking?** — anything stuck?
- **Relative priority** — high / medium / low
- **Key people** — link to person pages from Steps 2-3

Create project pages as you go. Don't over-structure. If the user says "it's kind of a mess right now," that's valid status.

## Step 5: The Big Picture (~5 min)

> "Almost done. Let me zoom out."

1. **"Who's missing?"** — Anyone important we didn't cover?
2. **"What keeps you up at night?"** — Biggest risks or concerns across everything?
3. **"Most important thing in the next 30 days?"** — If you could only make one thing happen?

Create any additional pages. Update project priorities based on answers.

## Step 6: Tools & Sources

> "Last thing — what tools do you use for communication and work? I'm going to check what I can already access."

Probe for available MCP tools by category (same check that /scan does):
- Email, calendar, messaging, meeting notes, task manager, CRM

For each category, report what's connected:
> "Here's what I can see:
> - Email: ✓ connected
> - Calendar: ✓ connected
> - Messaging: ✗ not connected
> - ..."

For anything not connected:
> "You can connect more sources later by adding MCP servers to Claude Code. The more I can see, the more useful /scan becomes. But everything works without them — I'll just focus on what's available."

Don't go down a rabbit hole of MCP setup. Note what's available and move on.

## Step 7: Generate Everything

1. **Context map** — Write `~/.costack/context-map.md` with the full picture: all projects, all people, priorities, commitments, risks.

2. **CLAUDE.md starter** — Generate a customized `~/.claude/CLAUDE.md` based on everything learned. Read the template at `~/.claude/skills/costack/templates/claude-md-starter.md` and fill it in with real data. Present it to the user:

   > "I've drafted a CLAUDE.md file based on everything you told me. This is what I'll read at the start of every session. Take a look and let me know if anything's wrong or missing."

   Write it to `~/.costack/claude-md-draft.md` first. The user copies it to `~/.claude/CLAUDE.md` when they're happy with it. **Never overwrite their existing CLAUDE.md without explicit permission.**

3. **Scan state** — Write `~/.costack/state/last-scan.md` with current timestamps.

4. **Memory index** — If the user mentioned specific preferences, quirks, or rules during the conversation ("I hate when AI is wordy", "never contact my clients directly"), save them as the first entries in `~/.costack/memory/MEMORY.md`.

## Step 8: Wrap Up

Present a summary:
- Number of people tracked
- Number of projects tracked
- Top 3 priorities
- Sources connected vs. not connected
- Any gaps or concerns spotted

Then:

> "You're all set. Here's what to do next:
>
> - **Review the CLAUDE.md draft** I saved at `~/.costack/claude-md-draft.md`. When it looks good, copy it to `~/.claude/CLAUDE.md`.
> - **Try `/scan`** to pull in the latest from your connected sources.
> - **Try `/derive`** after a scan to see what CoStack thinks needs attention.
>
> CoStack gets smarter over time. `/reflect` at the end of each week will refine your rules based on what actually happened."

## Interview Style

- **Keep pace brisk.** Don't linger longer than the user wants. Short answers are fine.
- **Breadth over depth.** Coverage now, detail later via /scan.
- **Don't push for more detail than offered.** Gaps are data too.
- **Be conversational, not interrogative.** This is a planning conversation, not a form.
- **Create pages immediately** after each person/project. The user should see their world taking shape as they talk.
- **Show progress.** After each round, briefly recap what was created.

## Safety Constraints

- **Notes directory and CoStack state files are the only write targets.**
- **Never overwrite existing CLAUDE.md** — always draft separately and let the user move it.
- **Never send messages** or modify external systems.
- **Never create pages for people the user didn't mention.** Wait for /scan.
