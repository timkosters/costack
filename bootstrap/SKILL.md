---
name: bootstrap
description: Initial setup interview — build CoStack's understanding of your world through a structured conversation
argument-hint: ""
---

# /bootstrap — Setup Interview

Build CoStack's understanding of your world through a structured conversation. This creates the initial person pages, project pages, and context map that /scan and /derive will maintain going forward.

## Before Starting

1. Read `~/.costack/config` for NOTES_DIR. If it doesn't exist, ask the user to run the setup script first.
2. Check if any person or project pages already exist in NOTES_DIR. If so, read them — don't ask the user to repeat what CoStack already knows.
3. Present what you found (if anything) and what's missing. Then begin the interview.

Say something like:

> "I'll ask you about your world in four rounds — your team, key collaborators, active projects, and the big picture. Each round takes about 5-10 minutes. I'll create pages as we go, so you'll see your context building up in real time. Ready?"

## Round 1: Your Team (~5-10 min)

The people you work with daily or weekly. For each person:

- **Name and role** — what do they do?
- **Current focus** — what are they working on right now?
- **Working relationship** — how do you interact? What do you need from them?
- **Communication** — where do you usually talk to them? How responsive are they?

Prompt naturally. Don't force a rigid format — let the user describe people however they want, and extract the structure yourself.

After each person is described, **immediately create their person page** in NOTES_DIR. Don't wait until the end of the round. Show the user what you created.

When the user runs out of names, move on. Don't push for completeness — people will be added over time through /scan.

## Round 2: Key Collaborators (~5-10 min)

External partners, clients, collaborators, advisors — people outside the core team who matter.

For each:

- **Who are they?** Name, organization, role.
- **Current state** — what's the relationship status? Active project together? Dormant? Exploratory?
- **Main contacts** — who specifically do you talk to?
- **Open asks** — anything pending between you?

Same pattern: create pages as you go. If a collaborator is connected to a team member from Round 1, note the link.

## Round 3: Projects (~5-10 min)

Everything the user is actively working on or responsible for.

For each project:

- **One-line description** — what is it?
- **Status** — where does it stand right now?
- **What's blocking?** — anything stuck?
- **Relative priority** — high / medium / low, or however the user thinks about it.
- **Key people** — who's involved? (Link to person pages from Rounds 1-2.)

Create project pages as you go. Link people to projects and projects to people.

Don't over-structure. If the user says "it's kind of a mess right now," that's valid status. Capture the real state, not an idealized version.

## Round 4: The Big Picture (~5 min)

Zoom out. Ask:

1. **"Who's missing?"** — Anyone important we didn't cover? People you interact with less frequently but who matter?
2. **"What keeps you up at night?"** — What are the biggest risks or concerns across everything?
3. **"Most important thing in the next 30 days?"** — If you could only make progress on one thing, what would it be?

Create any additional pages needed. Update project priorities based on the answers.

## Wrap Up

1. **Regenerate the context map** — Write `~/.costack/context-map.md` with the full picture: all projects, all tracked people, current priorities, open commitments, known risks.

2. **Present a summary**:
   - Number of people tracked
   - Number of projects tracked
   - Top 3 priorities as CoStack understands them
   - Any obvious gaps or concerns spotted during the interview

3. **Ask**: "Does this feel right? Anything major I'm missing or getting wrong?"

4. **Initialize scan state** — Write `~/.costack/state/last-scan.md` with current timestamps so the first /scan knows where to start.

## Interview Style

- **Keep pace brisk.** Don't linger on any one person or project longer than the user wants. If they give a short answer, accept it and move on.
- **Breadth over depth.** The goal is coverage, not exhaustive detail. /scan will fill in depth over time.
- **Don't push for more detail than offered.** If the user says "I don't know" or "it's complicated," note it and move on. Gaps are fine — they're data too.
- **Be conversational, not interrogative.** This should feel like a planning conversation, not a form to fill out.
- **Create pages immediately after each person/project is described.** Don't batch. The user should see their world taking shape as they talk.

## Safety Constraints

- **Notes directory is the only write target** (plus CoStack state files).
- **Never send messages** or modify external systems.
- **Never create pages for people the user didn't mention.** Wait for /scan to surface new contacts organically.
