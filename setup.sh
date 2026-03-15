#!/bin/bash
set -e

COSTACK_DIR="$HOME/.costack"
CLAUDE_SKILLS_DIR="$HOME/.claude/skills"

echo ""
echo "  CoStack - AI Chief of Staff for Claude Code"
echo "  ==========================================="
echo ""

# 1. Create CoStack working directory
echo "Creating CoStack workspace at $COSTACK_DIR ..."
mkdir -p "$COSTACK_DIR/memory/diary"
mkdir -p "$COSTACK_DIR/memory/reflections"
mkdir -p "$COSTACK_DIR/state"
mkdir -p "$COSTACK_DIR/templates"

# 2. Copy templates if they don't exist
if [ ! -f "$COSTACK_DIR/memory/MEMORY.md" ]; then
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  cp "$SCRIPT_DIR/templates/memory-index.md" "$COSTACK_DIR/memory/MEMORY.md"
  cp "$SCRIPT_DIR/templates/state-template.md" "$COSTACK_DIR/state/last-scan.md"
  echo "  Created memory index and state file."
else
  echo "  Memory index already exists, skipping."
fi

# 3. Copy page templates
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cp "$SCRIPT_DIR/templates/project.md" "$COSTACK_DIR/templates/project.md"
cp "$SCRIPT_DIR/templates/person.md" "$COSTACK_DIR/templates/person.md"
cp "$SCRIPT_DIR/templates/context-map.md" "$COSTACK_DIR/templates/context-map.md"
echo "  Copied page templates to $COSTACK_DIR/templates/."

# 4. Ask for notes directory
echo ""
echo "  CoStack works best with a notes directory (Obsidian, Logseq, or plain markdown)."
echo "  This is where CoStack writes context maps, person pages, and project pages."
echo ""
read -p "  Path to your notes directory (or press Enter to skip): " NOTES_DIR

if [ -n "$NOTES_DIR" ]; then
  # Expand ~ if present
  NOTES_DIR="${NOTES_DIR/#\~/$HOME}"
  if [ -d "$NOTES_DIR" ]; then
    echo "NOTES_DIR=$NOTES_DIR" > "$COSTACK_DIR/config"
    echo "  Saved notes directory: $NOTES_DIR"
  else
    echo "  Directory not found: $NOTES_DIR"
    echo "  You can set this later by editing $COSTACK_DIR/config"
    echo "NOTES_DIR=" > "$COSTACK_DIR/config"
  fi
else
  echo "NOTES_DIR=" > "$COSTACK_DIR/config"
  echo "  Skipped. You can set this later by editing $COSTACK_DIR/config"
fi

# 5. Show what to add to CLAUDE.md
echo ""
echo "  ============================================"
echo "  Setup complete!"
echo "  ============================================"
echo ""
echo "  CoStack installed 9 skills:"
echo "    /scan        - Scan your world for changes"
echo "    /derive      - Reason about what changes imply"
echo "    /drift       - Compare intentions vs. actual behavior"
echo "    /reflect     - Learn from sessions, update your CLAUDE.md"
echo "    /deep-reflect - Search old notes for connections to current themes"
echo "    /graduate    - Promote ideas from daily notes to standalone pages"
echo "    /humanize    - Remove AI patterns from your writing"
echo "    /bootstrap   - Initial setup interview"
echo "    /health      - System health check"
echo ""
echo "  Next steps:"
echo "    1. Run /bootstrap in Claude Code to set up your profile"
echo "    2. Review the starter CLAUDE.md template at:"
echo "       $SCRIPT_DIR/templates/claude-md-starter.md"
echo "    3. Copy relevant sections into your ~/.claude/CLAUDE.md"
echo ""
echo "  Full documentation: $SCRIPT_DIR/README.md"
echo ""
