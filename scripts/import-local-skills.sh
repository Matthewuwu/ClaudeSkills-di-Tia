#!/usr/bin/env bash
# Import your custom skills from a local machine INTO this repo.
#
# Run this ON THE MACHINE WHERE YOUR SKILLS LIVE (e.g. CachyOS), where
# ~/.claude/skills contains the real skill folders. A cloud session cannot
# reach your laptop, so populating the repo has to happen from your side.
#
# Usage:
#   cd /path/to/ClaudeSkills-di-Tia
#   ./scripts/import-local-skills.sh            # reads ~/.claude/skills
#   ./scripts/import-local-skills.sh /some/dir  # or a custom source
#   git add -A && git commit -m "Import skills" && git push
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="${1:-$HOME/.claude/skills}"

if [ ! -d "$SRC" ]; then
  echo "Source skills directory not found: $SRC" >&2
  exit 1
fi

# Skills named in the setup handoff (order preserved for the report).
WANTED=(superpowers ponytail impeccable obsidian-skills caveman \
        relazione-servizio-pp verbale-stradale foglio-viaggio-pp \
        statuto-agente-pp handoff)

echo "Importing skills from: $SRC"
echo "Into repo:             $REPO_DIR"
echo

imported=()
missing=()

copy_skill() {
  local src="$1" name="$2"
  rm -rf "${REPO_DIR:?}/$name"
  cp -r "$src" "$REPO_DIR/$name"
  imported+=("$name")
}

is_imported() {
  local n="$1" x
  for x in "${imported[@]:-}"; do [ "$x" = "$n" ] && return 0; done
  return 1
}

# 1) The explicitly wanted skills.
for name in "${WANTED[@]}"; do
  if [ -d "$SRC/$name" ] && [ -f "$SRC/$name/SKILL.md" ]; then
    copy_skill "$SRC/$name" "$name"
  else
    missing+=("$name")
  fi
done

# 2) Any other local skill folder (dir with a SKILL.md), except the built-in.
for dir in "$SRC"/*/; do
  [ -d "$dir" ] || continue
  name="$(basename "$dir")"
  [ -f "$dir/SKILL.md" ] || continue
  case "$name" in session-start-hook) continue ;; esac
  is_imported "$name" && continue
  copy_skill "$dir" "$name"
done

echo "Imported (${#imported[@]}): ${imported[*]:-none}"
echo "Missing  (${#missing[@]}): ${missing[*]:-none}"
echo
echo "Next:"
echo "  cd \"$REPO_DIR\""
echo "  git add -A && git commit -m 'Import skills' && git push"
