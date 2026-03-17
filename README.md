# CoStack

**CoStack turns Claude Code into an AI chief of staff.** It builds a living context map of your world — every person, project, and commitment — and keeps it updated by scanning your communication channels automatically.

Most people use Claude Code to write software. CoStack uses it to run your life.

## The Context Map

The core idea: Claude starts every conversation from zero. CoStack fixes that.

Run `/context-collect` and it sweeps across every source you have connected — email, calendar, messages, meeting notes, tasks, CRM — and builds a single context map of your world. Who you're working with, what's active, what's pending, what needs attention.

Run `/context-collect Sarah` and it pulls everything about Sarah from every source into one page. Every email, message, meeting note, calendar event, and task — assembled chronologically with commitments and open threads highlighted.

The context map updates every time you run it. Claude reads it at the start of every session. Your AI assistant finally knows what's going on.

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

CoStack adds ten skills to Claude Code. Each one puts Claude in a specific thinking mode.

| Skill | What it does |
|-------|-------------|
| `/context-collect` | Sweep all your sources, or focus on a specific person/project/topic. Builds and maintains your context map. |
| `/derive` | Reason about what the context means. Detects gaps, infers timelines, tracks follow-through, flags what needs attention. |
| `/drift` | Compare stated intentions vs. actual behavior. Surfaces the projects you keep saying matter but never touch. |
| `/reflect` | Analyze patterns across sessions. Propose improvements to your instructions so the system gets smarter over time. |
| `/deep-reflect` | Search years of old notes for connections to whatever you're working on now. |
| `/graduate` | Find ideas buried in daily notes that deserve their own page. |
| `/humanize` | Strip AI patterns from any piece of writing. 24-pattern checklist from em-dash overuse to significance inflation. |
| `/bootstrap` | First-run setup. Interviews you about your work, configures everything, builds your initial context. |
| `/health` | System diagnostic. Checks configuration, memory, state files, and freshness. |

The core loop: **collect** context from your world, **derive** what it means, **act** on what matters.

## How It Works

**The context map.** A single markdown file that snapshots your entire world: active projects with status, people with recent activity and pending commitments, upcoming deadlines, and cross-cutting patterns. Regenerated every time you run `/context-collect`. Claude reads it automatically at the start of every session.

**Focused collection.** Give `/context-collect` a name, project, or topic and it searches every connected source for anything related. Assembles everything into one page with timeline, key details, open threads, and source links. Useful before a meeting, when picking up a stale project, or when you need the full picture on anything.

**Two-phase pipeline.** Scanning and reasoning are separate. `/context-collect` checks every channel and classifies what's new. `/derive` reasons about implications — connecting dots, spotting gaps, inferring what's unsaid. Mixing observation with interpretation produces worse results at both.

**Layered memory.** CLAUDE.md rules load every session. A MEMORY.md index tracks deeper lessons. Your notes are searchable. Past session transcripts are queryable. Information flows down as it ages and up as it proves important. `/reflect` proposes rule improvements based on patterns it observes.

**Work taxonomy.** Everything fits into Workspace > Area > Project > Task. Areas are durable responsibilities that never complete. Projects have end states. Tasks are discrete actions. This lets CoStack track commitments at the right level.

## After Setup

CoStack works best as a daily habit.

**Morning:** `/context-collect` to sweep your sources, then `/derive` to figure out what matters.

**Before a meeting:** `/context-collect [person name]` to pull everything about them into one page.

**During the day:** Work normally. When you write something important, run `/humanize` on it.

**End of week:** `/reflect` to learn from the week. `/drift` to check if you're doing what you said you would.

CoStack adapts to whatever tools you have connected. If you've configured MCP servers for email, calendar, messaging, or anything else, CoStack scans them. If you haven't, it skips them gracefully. No specific tool is required.

## Design Philosophy

**Draft only, never send.** CoStack never sends messages, emails, or calendar invites on your behalf. It never deletes files or data. It drafts, and you decide what goes out. This is a hard constraint, not a default.

**Your data stays local.** Everything runs on your machine. CoStack reads from your configured sources and writes to local markdown files. No data is sent to external services beyond what Claude Code itself requires.

**Self-improving.** The diary/reflect cycle means the system learns from every session. When something goes wrong, `/reflect` traces the problem to its source and proposes a fix.

**Skills are thinking modes.** Each skill puts Claude in a specific cognitive role. `/context-collect` is methodical and completionist. `/derive` is connective and inferential. `/humanize` is editorial. The same model behaves differently depending on which skill frames the task.

## Who This Is For

Operators, founders, researchers, and knowledge workers who spend their days across too many channels and too many projects. People whose bottleneck is not writing code but keeping track of everything happening around them.

CoStack complements code-focused tools rather than replacing them. If you use Claude Code for development, CoStack adds a layer for everything else.

## Contributing

Contributions welcome. See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for system details.

**Good first contributions:**
- New signal classifiers for `/context-collect`
- Additional writing patterns for `/humanize`
- Documentation improvements

**Ground rules:**
- Keep skills focused. One cognitive job per skill.
- Maintain the safety model. Nothing that sends, deletes, or modifies external systems.
- Test with a real workflow, not just synthetic examples.

## License

MIT
