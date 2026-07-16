#!/usr/bin/env bash
# Import custom Claude skills from their REAL locations on this machine into
# this repo, then you review + commit + push.
#
# Skills are not stored in a single ~/.claude/skills folder. They are scattered:
#   - personal skills  -> ~/.config/Claude/local-agent-mode-sessions/skills-plugin/**/skills
#   - superpowers       -> ~/.claude/plugins/cache/**/superpowers/**/skills
#   - caveman           -> ~/.claude/plugins/**/caveman/**/skills
#   - anything you put  -> ~/.claude/skills
#
# Every folder that contains a SKILL.md is copied to the repo root as a
# top-level skill (plugin sub-skills are flattened), minus a denylist of
# Anthropic/cowork defaults. First source wins on name collisions.
#
# Usage:
#   ./scripts/import-local-skills.sh            # copy
#   DRY_RUN=1 ./scripts/import-local-skills.sh  # just show what it would copy
set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DRY_RUN="${DRY_RUN:-0}"

# Defaults / infra we never vendor (already present in every environment).
DENYLIST=" pdf docx xlsx pptx morning skill-creator schedule setup-cowork \
consolidate-memory example-skill example-command playground "

# Source "skills" directories, in PRIORITY order (first match of a name wins).
SRC_DIRS=()
add_dir() { [ -d "$1" ] && SRC_DIRS+=("$1"); }
add_find() { while IFS= read -r p; do [ -n "$p" ] && SRC_DIRS+=("$p"); done < <("$@"); }

add_dir "$HOME/.claude/skills"
# personal skills (scoped to skills-plugin so finance/rpm plugins are ignored)
while IFS= read -r p; do SRC_DIRS+=("$p"); done < <(
  find "$HOME/.config/Claude/local-agent-mode-sessions/skills-plugin" \
       -type d -name skills 2>/dev/null | sort)
# superpowers (highest version last -> take it first)
while IFS= read -r p; do SRC_DIRS+=("$p"); done < <(
  find "$HOME/.claude/plugins/cache" -type d -path '*superpowers*/skills' \
       2>/dev/null | sort -r)
# caveman (marketplace copy has the full set)
while IFS= read -r p; do SRC_DIRS+=("$p"); done < <(
  find "$HOME/.claude/plugins/marketplaces" -type d -path '*caveman*/skills' \
       2>/dev/null | sort)

if [ "${#SRC_DIRS[@]}" -eq 0 ]; then
  echo "No skill source directories found on this machine." >&2
  exit 1
fi

echo "Scanning sources:"; printf '  %s\n' "${SRC_DIRS[@]}"; echo

declare -A SEEN
imported=()
skipped_default=()
for d in "${SRC_DIRS[@]}"; do
  [ -d "$d" ] || continue
  for skill in "$d"/*/; do
    [ -d "$skill" ] || continue
    [ -f "${skill}SKILL.md" ] || continue
    name="$(basename "$skill")"
    case "$DENYLIST" in *" $name "*) skipped_default+=("$name"); continue ;; esac
    [ -n "${SEEN[$name]:-}" ] && continue
    SEEN[$name]=1
    if [ "$DRY_RUN" = "1" ]; then
      imported+=("$name  <- $skill")
    else
      rm -rf "${REPO_DIR:?}/$name"
      cp -r "$skill" "$REPO_DIR/$name"
      imported+=("$name")
    fi
  done
done

echo "Imported ${#imported[@]} skill(s):"
printf '  %s\n' "${imported[@]}" | sort
if [ "${#skipped_default[@]}" -gt 0 ]; then
  echo
  echo "Skipped defaults: $(printf '%s ' "${skipped_default[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')"
fi
echo
if [ "$DRY_RUN" = "1" ]; then
  echo "(dry run — nothing copied. Re-run without DRY_RUN=1 to copy.)"
else
  echo "Review with 'git status' / 'git diff --stat', then:"
  echo "  git add -A && git commit -m 'Import skills' && git push"
fi
