# ClaudeSkills-di-Tia

Single source of truth for my custom [Claude Code](https://claude.com/claude-code)
skills. This repo is consumed by other projects **as a git submodule**, and a
`SessionStart` hook copies the skills into `~/.claude/skills` so they are
available in every session — including [Claude Code on the web](https://claude.ai/code),
where there is no access to a local machine.

## Layout

Each skill is a top-level folder containing a `SKILL.md`:

```
ClaudeSkills-di-Tia/
├── superpowers/SKILL.md
├── ponytail/SKILL.md
├── caveman/SKILL.md
├── ...                       # one folder per skill
├── scripts/
│   └── import-local-skills.sh # populate this repo from a local machine
└── .claude/
    ├── settings.json          # registers the SessionStart hook
    └── hooks/
        └── sync-skills.sh      # copies skills into ~/.claude/skills
```

The sync hook copies **only** folders that contain a `SKILL.md`, so `README.md`,
`.claude/`, `scripts/`, and other repo metadata are never pushed into
`~/.claude/skills`.

## Populate the skills (run once, from your local machine)

A cloud session cannot read your laptop, so the skill *content* has to be
imported from the machine where `~/.claude/skills` actually lives:

```bash
git clone https://github.com/Matthewuwu/ClaudeSkills-di-Tia.git
cd ClaudeSkills-di-Tia
./scripts/import-local-skills.sh          # reads ~/.claude/skills
git add -A && git commit -m "Import skills" && git push
```

## Use these skills in another project (consumer setup)

In the project that should get the skills:

```bash
# 1. Add this repo as a submodule
git submodule add https://github.com/Matthewuwu/ClaudeSkills-di-Tia.git .claude/skills-shared

# 2. Copy the sync hook + settings from this repo into the project
mkdir -p .claude/hooks
cp .claude/skills-shared/.claude/hooks/sync-skills.sh .claude/hooks/
chmod +x .claude/hooks/sync-skills.sh
# merge .claude/skills-shared/.claude/settings.json into the project's
# .claude/settings.json (keep any existing keys)

git add .gitmodules .claude
git commit -m "Add shared skills submodule + sync hook"
git push
```

From then on, every session in that project runs the hook, which checks out the
submodule (if needed) and syncs the skills into `~/.claude/skills`.

## Update a skill everywhere

```bash
# edit a skill in this repo, then:
git commit -am "Tweak <skill>" && git push

# in each consumer project, pull the new revision:
git submodule update --remote .claude/skills-shared
git commit -am "Bump shared skills" && git push
```

The next session in the consumer project picks up the new version automatically.

## Notes

- The hook never fails in a blocking way: missing skills, no network, or an
  uninitialised submodule all degrade to a silent no-op (`exit 0`).
- Skills land in `~/.claude/skills` at session start and are picked up by the
  skill scan; if a session was already running, they are guaranteed available
  from the **next** session.
