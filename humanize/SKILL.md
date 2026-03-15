---
name: humanize
description: Remove signs of AI-generated writing from text — 24-pattern checklist for content that sounds human
argument-hint: "[text to humanize, or 'audit' to check a draft]"
---

# Humanize

Apply the anti-AI writing checklist to make text sound human.

## Instructions

1. Load the anti-AI writing checklist from `~/.claude/skills/costack/guidelines/anti-ai-writing.md`.

2. Determine mode from the user's argument:

### Direct Mode (user provides text)
- Scan the text against all 24 patterns in the checklist
- Apply fixes silently
- Return the cleaned version
- Below it, list what was changed and why (brief)

### Audit Mode (user says "audit")
- Ask what draft to check
- Run the two-pass audit:

**Pass 1 — Tell Detection**
Ask: "What makes this obviously AI-generated?" Scan against all 24 patterns. List every tell found with the specific text that triggered it.

**Pass 2 — Rewrite**
Fix every tell found in Pass 1. Present the clean version.

**Pass 3 — Soul Check**
After removing tells, check:
- **Sentence variety**: Are sentences all the same length? Mix short punchy with longer flowing.
- **Opinions present**: Does the writer have a take, or is it neutral reporting?
- **Mixed feelings**: Real humans have ambivalence. Flag if everything is uniformly positive or negative.
- **Specificity**: Concrete details beat abstract claims.
- **Imperfect structure**: Perfect three-part structure feels algorithmic. Tangents and asides are human.

Present the final version with a summary of all changes made.
