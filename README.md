# CoStack

**CoStack turns Claude Code into an AI chief of staff.** It scans your communication channels, tracks your commitments, surfaces what you're avoiding, and helps you write like a human.

Most people use Claude Code to write software. CoStack uses it to run your life.

## Get Started

**Option A — Let Claude walk you through it.**
Paste this repo's URL into [claude.ai](https://claude.ai) and say "help me set this up." Claude will read the guide and walk you through everything step by step.

**Option B — Install it yourself.**
```bash
git clone https://github.com/timkosters/costack.git ~/.claude/skills/costack && cd ~/.claude/skills/costack && ./setup.sh
```
Then open Claude Code and type `/bootstrap`.

Both paths end in the same place: a 20-minute setup interview where CoStack learns about your team, projects, and tools.

## What It Does

CoStack adds nine skills to Claude Code. Each one puts Claude in a specific thinking mode.

| Skill | What it does |
|-------|-------------|
| `/bootstrap` | First-run setup. Interviews you about your work, configures everything, builds your initial context. |
| `/scan` | Check your sources for new information: messages, emails, meetings, tasks. Classifies signals and updates your knowledge base. |
| `/derive` | Reason about what the new information means. Detects gaps, infers timelines, tracks follow-through, flags what needs attention. |
| `/drift` | Compare stated intentions vs. actual behavior. Surfaces the projects you keep saying matter but never touch. |
| `/reflect` | Analyze patterns across sessions. Propose improvements to your instructions so the system gets smarter over time. |
| `/deep-reflect` | Search years of old notes for connections to whatever you're working on now. |
| `/graduate` | Find ideas buried in daily notes that deserve their own page. |
| `/humanize` | Strip AI patterns from any piece of writing. 24-pattern checklist from em-dash overuse to significance inflation. |
| `/health` | System diagnostic. Checks configuration, memory, state files, and freshness. |

The core loop: **scan** your world, **derive** what it means, **act** on what matters.

## How It Works

**Layered instructions.** Claude Code loads CLAUDE.md files at multiple levels: global (your preferences), project-specific (per-workspace), and auto-loaded memory (lessons learned). CoStack's `/reflect` skill proposes improvements based on patterns it observes, so your instructions get sharper over time.

**Structured memory.** CLAUDE.md rules load every session. Below that, a MEMORY.md index tracks deeper topic files. Below that, your notes are searchable. At the bottom, parsed session transcripts let you search past conversations. Information flows down as it ages and up as it proves important.

**Two-phase context pipeline.** Scanning and reasoning are separate. `/scan` checks every channel and classifies what's new. `/derive` reasons about implications — connecting dots, spotting gaps, inferring what's unsaid. Mixing observation with interpretation produces worse results at both.

**Work taxonomy.** Everything fits into Workspace > Area > Project > Task. Areas are durable responsibilities that never complete. Projects have end states. Tasks are discrete actions. This lets CoStack track commitments at the right level.

## After Setup

CoStack works best as a daily habit.

**Morning:** `/scan` to pull in context, then `/derive` to figure out what matters.

**During the day:** Work normally. When you write something important, run `/humanize` on it.

**End of week:** `/reflect` to learn from the week. `/drift` to check if you're doing what you said you would.

CoStack adapts to whatever tools you have connected. Email, calendar, messaging, task manager, CRM — if you've configured MCP servers for them, CoStack scans them. If you haven't, it skips them gracefully. No specific tool is required.

## Design Philosophy

**Draft only, never send.** CoStack never sends messages, emails, or calendar invites on your behalf. It never deletes files or data. It drafts, and you decide what goes out. This is a hard constraint, not a default.

**Your data stays local.** Everything runs on your machine. CoStack reads from your configured sources and writes to local markdown files. No data is sent to external services beyond what Claude Code itself requires.

**Self-improving.** The diary/reflect cycle means the system learns from every session. When something goes wrong, `/reflect` traces the problem to its source and proposes a fix.

**Skills are thinking modes.** Each skill puts Claude in a specific cognitive role. `/scan` is methodical and completionist. `/derive` is connective and inferential. `/humanize` is editorial. The same model behaves differently depending on which skill frames the task.

## Who This Is For

Operators, founders, researchers, and knowledge workers who spend their days across too many channels and too many projects. People whose bottleneck is not writing code but keeping track of everything happening around them.

CoStack complements code-focused tools rather than replacing them. If you use Claude Code for development, CoStack adds a layer for everything else.

## Contributing

Contributions welcome. See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for system details.

**Good first contributions:**
- New signal classifiers for `/scan`
- Additional writing patterns for `/humanize`
- Documentation improvements

**Ground rules:**
- Keep skills focused. One cognitive job per skill.
- Maintain the safety model. Nothing that sends, deletes, or modifies external systems.
- Test with a real workflow, not just synthetic examples.

## License

MIT
