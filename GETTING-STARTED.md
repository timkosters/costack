# Getting Started with CoStack

This guide is designed to be read by Claude when someone pastes this repo into a Claude conversation. If you're reading this as a human, you can follow along too — but the easiest way is to paste the repo URL into claude.ai and say "help me set this up."

---

## What CoStack Is

CoStack turns Claude Code into an AI chief of staff. It adds skills for scanning your communication channels, tracking commitments, surfacing what you're avoiding, and writing like a human. It's for people who manage lots of projects and relationships — founders, operators, researchers, anyone whose bottleneck is keeping track of everything, not writing code.

## Prerequisites

CoStack runs inside **Claude Code** (Anthropic's CLI tool). The person needs Claude Code installed and working before they can use CoStack.

**Check first**: Ask if they have Claude Code installed. If they're not sure, it's the terminal-based Claude tool (not the claude.ai website, not the desktop app). They can check by opening their terminal and typing `claude`. If it works, they have it.

**If they don't have Claude Code**: Walk them through installing it:
1. Open Terminal (on Mac: press Cmd+Space, type "Terminal", press Enter)
2. Run: `npm install -g @anthropic-ai/claude-code`
3. If they don't have npm/Node.js, they need that first: https://nodejs.org (download the LTS version, install it, then try the npm command again)
4. After installing, run `claude` in terminal to verify it works. It will ask them to log in with their Anthropic account.

## Installation

Once Claude Code is working, they need to run ONE command in their terminal:

```bash
git clone https://github.com/timkosters/costack.git ~/.claude/skills/costack && cd ~/.claude/skills/costack && ./setup.sh
```

**If they don't have git**: They can install it at https://git-scm.com or on Mac just run `xcode-select --install` in terminal.

This command:
1. Downloads CoStack into the right folder (where Claude Code discovers skills)
2. Creates a `~/.costack/` folder for CoStack's memory and state
3. Prints a success message

The whole thing takes about 10 seconds.

## First Run

After installation, tell them:

1. **Open Claude Code** — type `claude` in terminal (or open it in VS Code if they use the extension)
2. **Type `/bootstrap`** — this starts the setup interview
3. **Answer the questions** — CoStack will ask about their role, team, projects, and tools. Takes about 20 minutes. It creates pages and builds context as you talk.

That's it. After bootstrap, they can use `/scan` daily to check their sources and `/derive` to reason about what needs attention.

## If They Get Stuck

Common issues:
- **"command not found: claude"** — Claude Code isn't installed. Go back to prerequisites.
- **"command not found: git"** — Need to install git first.
- **"/bootstrap doesn't work"** — The clone probably went to the wrong directory. Check that `~/.claude/skills/costack/bootstrap/SKILL.md` exists.
- **"I don't have a notes app"** — That's fine. During /bootstrap, CoStack will offer to create a simple folder for notes. No special app needed.

## What Happens During Bootstrap

So they know what to expect:
1. **Quick setup** (~2 min) — Where to store notes, what they do, where they're based
2. **Team** (~5-10 min) — People they work with regularly
3. **Collaborators** (~5-10 min) — External partners, clients, advisors
4. **Projects** (~5-10 min) — What they're actively working on
5. **Big picture** (~5 min) — Risks, priorities, what matters most
6. **Tools** (~2 min) — What communication tools they use (CoStack checks what's connected)
7. **Setup** — Generates their configuration and context map

After bootstrap, CoStack knows their world and is ready to work.

## Daily Usage (After Setup)

The core loop:
- **Morning**: Type `/scan` — checks email, calendar, messages, tasks for what's new
- **After scan**: Type `/derive` — reasons about what the new information means
- **When writing**: Type `/humanize` on any draft to strip AI patterns
- **End of week**: Type `/reflect` — proposes improvements to the system

CoStack gets smarter over time. Each session teaches it more about preferences and patterns.
