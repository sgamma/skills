# CLAUDE.md

This repo is a collection of Claude Code skills, versioned so they improve over time.

## Layout

- `skills/<category>/<name>/SKILL.md` — one skill per folder. `category` is `engineering` (broadly useful) or `soloterm` (Solo-MCP session workflow, tied to my own setup). `name` is the folder name and becomes the symlink name in `~/.claude/skills/`.
- `scripts/link-skills.sh` — symlinks every skill into `~/.claude/skills/`.
- `scripts/list-skills.sh` — lists skills + descriptions.
- `.claude-plugin/plugin.json` — plugin manifest; **keep its `skills` array in sync** when adding/removing/moving a skill.

## Adding or editing a skill

1. Create or edit `skills/<category>/<name>/SKILL.md`. Frontmatter needs `name:` and a `description:` whose second sentence is `Use when …` (the trigger the agent matches on).
2. If you added/moved a skill, add its path to `.claude-plugin/plugin.json`.
3. Run `./scripts/link-skills.sh` to (re)link into `~/.claude/skills/`.
4. Keep `SKILL.md` lean; push detail into sibling reference files loaded on demand (the same progressive-disclosure idea the `optimize-claude-md` skill applies to a project's CLAUDE.md).
