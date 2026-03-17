#!/bin/bash
set -e

COSTACK_DIR="$HOME/.costack"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Create CoStack workspace (silent)
mkdir -p "$COSTACK_DIR/memory/diary"
mkdir -p "$COSTACK_DIR/memory/reflections"
mkdir -p "$COSTACK_DIR/state"
mkdir -p "$COSTACK_DIR/templates"

# Copy templates if first run
if [ ! -f "$COSTACK_DIR/memory/MEMORY.md" ]; then
  cp "$SCRIPT_DIR/templates/memory-index.md" "$COSTACK_DIR/memory/MEMORY.md"
  cp "$SCRIPT_DIR/templates/state-template.md" "$COSTACK_DIR/state/last-scan.md"
fi

# Always update page templates to latest
cp "$SCRIPT_DIR/templates/project.md" "$COSTACK_DIR/templates/project.md"
cp "$SCRIPT_DIR/templates/person.md" "$COSTACK_DIR/templates/person.md"
cp "$SCRIPT_DIR/templates/context-map.md" "$COSTACK_DIR/templates/context-map.md"

# Create empty config if it doesn't exist
if [ ! -f "$COSTACK_DIR/config" ]; then
  echo "NOTES_DIR=" > "$COSTACK_DIR/config"
fi

echo ""
echo "  CoStack installed successfully."
echo ""
echo "  Next step: Open Claude Code and type /bootstrap"
echo ""
