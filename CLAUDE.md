# ClaudeSkills-di-Tia

This repository is the source of truth for my custom Claude Code skills. Each
top-level folder with a `SKILL.md` is one skill.

## Skill condivise

Le skill custom vivono in questo repo (una cartella per skill, con `SKILL.md`).
Un hook `SessionStart` (`.claude/hooks/sync-skills.sh`) le sincronizza in
`~/.claude/skills` a ogni avvio di sessione, comprese le sessioni cloud su
claude.ai/code.

- **Popolare il repo** (dalla macchina locale, dove esistono le skill):
  `./scripts/import-local-skills.sh` → `git add -A && git commit && git push`.
- **Consumare da un altro progetto**: aggiungerlo come submodule in
  `.claude/skills-shared` e copiarci l'hook + il merge di `.claude/settings.json`
  (vedi README).
- **Aggiornare le skill in un consumer**:
  `git submodule update --remote .claude/skills-shared` → commit → push. La
  sessione cloud successiva usa la versione nuova.

L'hook non fallisce mai in modo bloccante: fallback silenziosi ovunque, `exit 0`.

## Working here

- Editing a skill = editing its `SKILL.md` (and any support files) in place.
- Do not add machine-specific settings to `.claude/settings.json`; use
  `.claude/settings.local.json` (git-ignored) instead.
