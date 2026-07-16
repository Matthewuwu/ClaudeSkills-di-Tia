#!/usr/bin/env bash
# Export new/modified skills from a CONSUMER PROJECT back into the shared
# skills submodule, so ClaudeSkills-di-Tia can be updated with work you did
# while inside that project.
#
# Run this FROM the root of a project that has the shared-skills submodule
# at .claude/skills-shared:
#
#   .claude/skills-shared/scripts/export-new-skills.sh
#
# It only copies files into the submodule's working tree. It NEVER runs
# `git commit` or `git push` — you always review and publish yourself with
# the commands printed at the end.
set -uo pipefail

PROJECT_DIR="$(pwd)"
SHARED="$PROJECT_DIR/.claude/skills-shared"

if [ ! -d "$SHARED" ]; then
  echo "No .claude/skills-shared submodule found in: $PROJECT_DIR" >&2
  echo "Run this from the root of a project set up with the shared-skills submodule." >&2
  exit 1
fi

# Local sources that might contain skills newer than the shared repo.
CANDIDATES=(
  "$PROJECT_DIR/.claude/skills"   # project-scoped skills for this repo
  "$HOME/.claude/skills"          # personal skills (global to this machine)
)

new_skills=()
modified_skills=()
unchanged=0

for src_root in "${CANDIDATES[@]}"; do
  [ -d "$src_root" ] || continue
  for skill in "$src_root"/*/; do
    [ -d "$skill" ] || continue
    [ -f "${skill}SKILL.md" ] || continue
    name="$(basename "$skill")"
    target="$SHARED/$name"

    if [ ! -d "$target" ]; then
      new_skills+=("$name|$skill")
    elif ! diff -rq "$skill" "$target" >/dev/null 2>&1; then
      modified_skills+=("$name|$skill")
    else
      unchanged=$((unchanged + 1))
    fi
  done
done

if [ "${#new_skills[@]}" -eq 0 ] && [ "${#modified_skills[@]}" -eq 0 ]; then
  echo "Nothing to export — $unchanged skill(s) already match the shared repo."
  exit 0
fi

if [ "${#new_skills[@]}" -gt 0 ]; then
  echo "New (${#new_skills[@]}):"
  for e in "${new_skills[@]}"; do echo "  ${e%%|*}"; done
fi
if [ "${#modified_skills[@]}" -gt 0 ]; then
  echo "Modified (${#modified_skills[@]}):"
  for e in "${modified_skills[@]}"; do echo "  ${e%%|*}"; done
fi
echo

read -r -p "Copy these into .claude/skills-shared? [y/N] " ans
case "$ans" in
  y|Y) ;;
  *) echo "Aborted — nothing copied."; exit 0 ;;
esac

for e in "${new_skills[@]}" "${modified_skills[@]}"; do
  [ -n "$e" ] || continue
  name="${e%%|*}"; src="${e#*|}"
  rm -rf "${SHARED:?}/$name"
  cp -r "$src" "$SHARED/$name"
  echo "  copied: $name"
done

echo
echo "Copied — nothing committed or pushed yet. Publish with:"
echo
echo "  cd \"$SHARED\""
echo "  git add -A && git commit -m 'Update skills from $(basename "$PROJECT_DIR")' && git push"
echo "  cd \"$PROJECT_DIR\""
echo "  git add .claude/skills-shared && git commit -m 'Bump shared skills' && git push"
