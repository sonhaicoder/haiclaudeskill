#!/usr/bin/env bash
# uninstall.sh — remove symlinks pointing to this repo từ ~/.claude/skills/
# Backup ở ~/.claude/skills.bak/ KHÔNG bị động — anh restore manual nếu cần.
set -euo pipefail

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SKILLS_SRC="$REPO_DIR/skills"
SKILLS_DST="$HOME/.claude/skills"

REMOVED=0
SKIPPED=0

for skill_path in "$SKILLS_SRC"/*/; do
  skill_name="$(basename "$skill_path")"
  dest="$SKILLS_DST/$skill_name"

  if [[ -L "$dest" ]]; then
    current_target="$(readlink "$dest")"
    if [[ "$current_target" == "$skill_path" || "$current_target" == "${skill_path%/}" ]]; then
      rm "$dest"
      echo "  ✗ $skill_name — symlink removed"
      REMOVED=$((REMOVED+1))
      continue
    fi
  fi

  echo "  ⊘ $skill_name — not a symlink to this repo (skipping)"
  SKIPPED=$((SKIPPED+1))
done

echo ""
echo "═══════════════════════════════════════"
echo "  Removed:  $REMOVED symlinks"
echo "  Skipped:  $SKIPPED (not linked to this repo)"
echo "═══════════════════════════════════════"
echo ""

# List backups
LATEST_BAK="$(ls -td $HOME/.claude/skills.bak/*/ 2>/dev/null | head -1 || true)"
if [[ -n "$LATEST_BAK" ]]; then
  echo "Latest backup: $LATEST_BAK"
  echo "Restore manually with:"
  echo "  cp -R $LATEST_BAK* ~/.claude/skills/"
fi
