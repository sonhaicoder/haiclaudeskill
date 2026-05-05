#!/usr/bin/env bash
# install.sh — symlink toàn bộ skills từ repo vào ~/.claude/skills/
# Skills cũ trùng tên sẽ được backup vào ~/.claude/skills.bak/<timestamp>/
set -euo pipefail

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SKILLS_SRC="$REPO_DIR/skills"
SKILLS_DST="$HOME/.claude/skills"
BACKUP_DIR="$HOME/.claude/skills.bak/$(date +%Y%m%d-%H%M%S)"

if [[ ! -d "$SKILLS_SRC" ]]; then
  echo "ERROR: $SKILLS_SRC not found"
  exit 1
fi

mkdir -p "$SKILLS_DST"

INSTALLED=0
BACKED_UP=0
SKIPPED=0

for skill_path in "$SKILLS_SRC"/*/; do
  skill_name="$(basename "$skill_path")"
  dest="$SKILLS_DST/$skill_name"

  # Backup nếu đã tồn tại (file hoặc dir, không phải symlink trỏ về repo)
  if [[ -e "$dest" || -L "$dest" ]]; then
    # Check nếu symlink đã trỏ đúng repo → skip
    if [[ -L "$dest" ]]; then
      current_target="$(readlink "$dest")"
      if [[ "$current_target" == "$skill_path" || "$current_target" == "${skill_path%/}" ]]; then
        echo "  ✓ $skill_name — already linked"
        SKIPPED=$((SKIPPED+1))
        continue
      fi
    fi

    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/"
    echo "  📦 $skill_name — backed up to $BACKUP_DIR/"
    BACKED_UP=$((BACKED_UP+1))
  fi

  ln -s "${skill_path%/}" "$dest"
  echo "  ✓ $skill_name — symlinked"
  INSTALLED=$((INSTALLED+1))
done

echo ""
echo "═══════════════════════════════════════"
echo "  Installed:  $INSTALLED skills"
echo "  Backed up:  $BACKED_UP skills (in $BACKUP_DIR)"
echo "  Skipped:    $SKIPPED already-linked skills"
echo "═══════════════════════════════════════"
echo ""
echo "Next steps:"
echo "  1. Restart Claude Code (skills load on start)"
echo "  2. Run 'ls ~/.claude/skills/' to verify"
echo "  3. To uninstall: ./uninstall.sh"
