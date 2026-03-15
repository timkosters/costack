# CoStack Architecture

This document describes how CoStack works at a structural level. Read this if you want to understand the design decisions, extend the system, or build something similar.

## System Overview

CoStack has five layers, each with a distinct role:

```
Layer 5: Output         Where CoStack writes (knowledge base, daily notes, drafts)
Layer 4: Sources        Where CoStack reads (email, calendar, messages, tasks, notes)
Layer 3: Skills         How CoStack thinks (9 cognitive modes, loaded on demand)
Layer 2: Memory         What CoStack knows (layered from rules to deep history)
Layer 1: Instructions   How CoStack behaves (CLAUDE.md hierarchy)
```

Information flows upward during scanning (sources to memory to output) and downward during reflection (output patterns back to instructions). This bidirectional flow is what makes the system self-improving.

## Layer 1: The CLAUDE.md Hierarchy

Claude Code loads instruction files automatically at multiple levels. CoStack uses this to create a cascade of increasingly specific context.

**Global CLAUDE.md** (`~/.claude/CLAUDE.md`)
The top-level file loaded into every session regardless of working directory. Contains your identity, universal rules, communication preferences, safety constraints, and writing style. Target length: under 200 lines. This file should be ruthlessly edited. Every line costs attention in every session.

**Project CLAUDE.md** (per-workspace)
Loaded when you're working inside a specific directory. Contains workspace-specific conventions, file locations, and behavioral guidelines. A project CLAUDE.md for your notes directory would describe folder structure and tagging conventions. One for a code project would describe architecture and testing patterns.

**MEMORY.md** (auto-loaded, per-project)
Claude Code automatically loads the first ~200 lines of MEMORY.md files in the project memory directory. This is where hard-won lessons accumulate: things that went wrong, integrations that need special handling, patterns that emerged over time. Unlike CLAUDE.md (which you curate), MEMORY.md grows organically through use.

**Skills** (loaded on demand)
Each skill's prompt file is only loaded when that skill is invoked. This keeps the base context lean. A skill prompt can be substantial (the `/humanize` checklist is 24 patterns) without costing anything in sessions that don't use it.

**Why this hierarchy matters.** Different contexts need different instructions. Your writing style rules should load everywhere. Your notes directory conventions should only load when you're working in that directory. Detailed scanning instructions should only load when you invoke `/scan`. The hierarchy lets you be specific without being bloated.

## Layer 2: Memory Architecture

CoStack organizes what it knows into five tiers, ordered by loading cost and access pattern.

### Tier 1: CLAUDE.md Rules
**Loaded:** Every session, automatically.
**Contains:** Behavioral rules, preferences, safety constraints, writing style.
**Updated by:** `/reflect` (proposes changes, you approve).

This is the most expensive tier per-line because every line is read in every session. Keep it tight. A rule belongs here only if violating it would cause problems in most sessions.

### Tier 2: MEMORY.md Index
**Loaded:** Every session, automatically (first ~200 lines).
**Contains:** References to topic files, key lessons, disambiguation notes, integration gotchas.
**Updated by:** Skills that learn something worth remembering.

Think of this as a table of contents for your system's accumulated knowledge. Each entry either contains the lesson directly (if brief) or points to a topic file (if detailed). When CoStack encounters a situation covered by a MEMORY.md entry, it knows to load the relevant topic file.

### Tier 3: Topic Files
**Loaded:** On demand, when referenced by MEMORY.md or a skill.
**Contains:** Detailed knowledge about specific domains (CRM patterns, messaging scripts, integration workflows, contact databases).
**Updated by:** Skills and manual edits.

Topic files are the workhorses of long-term memory. They can be as long as needed because they're only loaded when relevant. A topic file about your calendar integration might include authentication patterns, known bugs, and workarounds. One about your CRM might map field names to semantic meanings.

### Tier 4: Knowledge Base
**Loaded:** Via search (grep, glob, or semantic search).
**Contains:** Your markdown notes, project pages, daily journals, meeting notes, research.
**Updated by:** `/scan` (updates person and project pages), `/graduate` (promotes ideas), `/deep-reflect` (surfaces connections).

This is your actual knowledge, accumulated over months or years. CoStack doesn't try to load it all. Instead, it searches when context is needed. Semantic search finds conceptually related notes. Grep finds exact references. The combination means CoStack can draw on deep history without loading it upfront.

### Tier 5: Session History
**Loaded:** Via semantic search.
**Contains:** Parsed transcripts of past conversations with Claude.
**Updated by:** Automatic parsing (nightly or per-session).

Session history lets CoStack reference past conversations. "We discussed this last week" becomes a searchable query. Over time, this builds a longitudinal record of decisions, explorations, and abandoned ideas. The search interface means you can ask "what did we decide about X?" and get an actual answer.

### What Goes Where

| If the knowledge is... | It belongs in... |
|------------------------|-----------------|
| A rule that applies to every session | CLAUDE.md (Tier 1) |
| A lesson learned the hard way | MEMORY.md (Tier 2) |
| Detailed domain knowledge | Topic file (Tier 3) |
| Your notes, journals, research | Knowledge base (Tier 4) |
| A past conversation | Session history (Tier 5) |
| Temporary, session-specific | Nowhere (let it expire) |

The key insight: information should be promoted upward when it proves repeatedly useful, and demoted downward when it becomes stale. `/reflect` handles upward promotion. `/health` flags staleness.

## Layer 3: Skills

Each skill is a prompt file that frames a specific cognitive task. Skills are not code. They are structured instructions that put Claude in a particular thinking mode with particular constraints.

### Skill Anatomy

A skill prompt typically contains:

1. **Role framing.** What cognitive mode to operate in (methodical scanner, connective reasoner, editorial critic).
2. **Input specification.** What sources to check, what files to read, what context to load.
3. **Processing instructions.** Step-by-step reasoning patterns, classification schemes, output formats.
4. **Safety constraints.** What the skill is allowed to do and, critically, what it is not.
5. **Output specification.** Where to write results, what format to use, what to surface to the user.

### Skill Interactions

Skills are designed to compose. The standard workflow chains several skills:

```
/scan  -->  /derive  -->  (user works)  -->  /reflect
```

`/scan` produces classified signals. `/derive` consumes those signals and produces implications. The user works based on those implications. `/reflect` analyzes what happened and proposes system improvements.

Other compositions:

- `/deep-reflect` feeds into `/graduate` (found an old idea worth promoting)
- `/health` feeds into `/reflect` (system issues suggest rule changes)
- `/humanize` is standalone (editorial pass on any text)
- `/drift` is standalone (behavioral audit over time)

## Layer 4: The Context Pipeline

The context pipeline is CoStack's core loop. It has two phases that are deliberately kept separate.

### Phase 1: Scan

The scan phase is mechanical and completionist. Its job is to check every configured source and classify what's new.

**Sources** are anything CoStack can read: messaging platforms, email, calendar, task managers, meeting note tools. CoStack doesn't prescribe specific tools. During `/bootstrap`, it discovers what MCP servers you have configured and builds its source list accordingly.

**Signal classification.** Each piece of new information is classified into one of six types:

| Signal type | Meaning | Example |
|-------------|---------|---------|
| `status-update` | Progress on something known | "We shipped the landing page" |
| `relationship-update` | Change in a relationship dynamic | "They're interested in partnering" |
| `commitment` | Someone committed to doing something | "I'll send the deck by Friday" |
| `completion` | Something was finished | "Invoice paid" |
| `signal` | Weak indicator worth noting | "They mentioned fundraising" |
| `new-entity` | A new person, org, or project appeared | "Met someone at the conference" |

**Page updates.** After classifying signals, the scan phase updates relevant pages in your knowledge base: person pages get new interaction history, project pages get status updates, the context map gets regenerated.

**Why scanning is separate.** Scanning requires a completionist mindset: check every channel, miss nothing, classify precisely. This is fundamentally different from the creative reasoning that `/derive` performs. Mixing them means you either rush through channels (missing signals) or over-interpret while scanning (biased classification).

### Phase 2: Derive

The derive phase is creative and inferential. Its job is to reason about what the scanned information implies.

**Five reasoning patterns:**

1. **Gap detection.** What's missing? If a project has a deadline but no recent activity, that's a gap. If someone promised a deliverable and went quiet, that's a gap. If a meeting is scheduled but there's no prep, that's a gap.

2. **Timeline inference.** What do the signals imply about timing? If a partner mentioned "next quarter" three weeks ago, that's now imminent. If a task was due yesterday and isn't done, the timeline has shifted.

3. **Priority shift impact.** When one project changes priority, what cascades? If a new opportunity demands attention, what existing commitments get squeezed? CoStack traces the second-order effects.

4. **Pattern recognition.** What keeps happening? If the same type of task gets postponed every week, that's a pattern. If certain relationships only activate around deadlines, that's a pattern. `/drift` extends this over longer timeframes.

5. **Follow-through tracking.** Who said they'd do what, and did they? CoStack tracks commitments (both yours and others') and flags when follow-through stalls.

**Output.** The derive phase produces a prioritized list of observations, each tagged with its reasoning pattern and confidence level. High-confidence gaps surface prominently. Weak pattern matches are noted but not emphasized.

## Layer 5: Output

CoStack writes to your local filesystem. The primary output targets:

**Knowledge base pages.** Person pages, project pages, and context maps are updated during scans. These pages accumulate context over time, so future sessions start with rich background.

**Daily notes.** Scan results, derive observations, and reflect proposals are summarized in daily note entries. This creates a chronological record of what CoStack surfaced and what you did about it.

**Drafts.** When CoStack helps compose messages, emails, or documents, the output is always a draft presented in the conversation. Never written directly to an outbound system.

**System files.** CLAUDE.md and MEMORY.md updates proposed by `/reflect` are written after your approval.

## The Taxonomy

CoStack organizes work into four levels:

```
Workspace > Area > Project > Task
```

**Workspace.** The top-level domain. Most people have two or three: their primary job, personal life, a side project. Workspaces determine which context files load and which sources get scanned.

**Area.** A durable area of responsibility that never completes. "Marketing," "operations," "health," "home." Areas are just a metadata field on pages, not a separate entity. They group related work without requiring their own tracking.

**Project.** An initiative with a clear end state. "Launch the website," "hire a designer," "plan the offsite." Projects get their own pages with action items, context, and links to related people and tasks.

**Task.** A discrete action with a clear "done" state. Most tasks are checkboxes on project pages. A task only gets its own page if it requires research, decisions, or multiple steps.

**Discovery.** CoStack finds projects and tasks by scanning frontmatter tags in your knowledge base. Pages tagged with `type: project` or `type: task` are tracked. Status tags like `active`, `needs-review`, or `decision-needed` drive prioritization.

**Why this matters.** Without a taxonomy, commitments live at random levels of abstraction. "Fix the bug" and "expand to Europe" sit in the same task list. The taxonomy forces clarity about what level of commitment something represents, which drives better prioritization.

## The Self-Improvement Loop

CoStack gets smarter over time through a five-stage loop:

```
1. Diary capture    -->  Raw observations from each session
2. Session parsing  -->  Structured transcripts (searchable)
3. /reflect         -->  Pattern analysis across sessions
4. CLAUDE.md update -->  Rule changes (with your approval)
5. /health          -->  Staleness audits, decluttering
```

### The "Fix at the Source" Principle

When something goes wrong, the fix belongs at the source of the behavior, not as an extra rule layered on top.

Example: CoStack produces overly formal drafts. The wrong fix is adding a rule "be less formal." The right fix is finding the instruction that's causing formality (maybe an overly specific writing guide) and rewriting it.

This principle prevents rule accumulation. Without it, CLAUDE.md grows monotonically as new rules pile on top of old ones. Contradictions emerge. The original source of the bad behavior keeps winning because it's more specific than the patch.

`/reflect` is trained to look for the source first: find what's currently driving the bad output, fix that, and only add a new rule as a last resort.

### Decluttering

Memory accumulates. Without maintenance, MEMORY.md grows unwieldy, topic files go stale, and CLAUDE.md drifts past its target length. `/health` audits for:

- CLAUDE.md lines exceeding the target (suggest consolidation)
- MEMORY.md entries that reference deleted files
- Topic files not accessed in 30+ days (suggest archival)
- Knowledge base pages with broken links
- Duplicate or contradictory rules

Decluttering is always proposed, never automatic. You decide what stays and what goes.

## The Safety Model

CoStack operates under hard constraints that cannot be overridden by any skill or instruction.

### Never Send

CoStack never sends messages, emails, calendar invites, or any outbound communication on any platform. It drafts content and presents it to you. You copy, review, edit, and send yourself. This is not a convenience feature. It is a safety boundary.

**Why.** An AI assistant that can send messages on your behalf is one hallucination away from damaging a relationship. The cost of copy-pasting a draft is trivial compared to the cost of an errant message sent to the wrong person or with the wrong tone.

### Never Delete

CoStack never deletes files, emails, calendar events, contacts, tasks, or any other data in any system. It can create and edit, but not destroy.

**Why.** Deletion is irreversible in most systems. An AI assistant that can delete is one misunderstanding away from data loss. Creation and editing are safe to automate. Deletion is not.

### Never Modify External Systems Without Consent

CoStack reads broadly but writes narrowly. It reads from all configured sources during scans. It writes almost exclusively to local files (your knowledge base, CLAUDE.md, daily notes). The few exceptions (creating a task in a task manager, for example) are explicitly scoped per-skill and always flagged to the user.

### Per-Skill Constraints

Each skill has its own safety boundary in addition to the global rules:

| Skill | Allowed writes |
|-------|---------------|
| `/scan` | Knowledge base pages (person, project, context map) |
| `/derive` | Knowledge base pages, sparse task creation (1-3 per run) |
| `/drift` | Knowledge base (drift report) |
| `/reflect` | CLAUDE.md, MEMORY.md (with approval) |
| `/deep-reflect` | Daily note entry |
| `/graduate` | Knowledge base (new pages from daily note ideas) |
| `/humanize` | None (output in conversation only) |
| `/bootstrap` | CLAUDE.md, MEMORY.md, CoStack config files |
| `/health` | None (diagnostic only, proposes changes) |

## Customization Points

CoStack is designed to be modified. Here's what you should customize versus what works out of the box.

### You Should Customize

**Your CLAUDE.md files.** `/bootstrap` generates a starting point, but your instructions should evolve with use. `/reflect` proposes changes. You approve and refine them.

**Source configuration.** Which communication channels to scan, which to skip, priority ordering. This depends entirely on your tools and workflow.

**Taxonomy.** Your workspaces and areas reflect your life, not a template. Define them during `/bootstrap` and evolve them as your responsibilities change.

**Writing style rules.** The `/humanize` checklist is a starting point. Add patterns specific to your voice. Remove ones that don't match your style.

**Knowledge base conventions.** Folder structure, frontmatter fields, tagging schemes. CoStack adapts to your conventions rather than imposing its own.

### Works Out of the Box

**The context pipeline.** The scan/derive split, signal classification scheme, and reasoning patterns work without modification.

**The memory hierarchy.** The five-tier system and promotion/demotion logic are general-purpose.

**The self-improvement loop.** Diary capture, session parsing, and reflect analysis work regardless of your domain.

**Safety constraints.** The never-send, never-delete rules are universal. Don't weaken them.

**Skill composition.** The scan-derive-reflect chain works for any knowledge worker workflow.
