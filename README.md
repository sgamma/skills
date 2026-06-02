# Claude Code Skills

[![install: npx skills add sgamma/skills](https://img.shields.io/badge/install-npx_skills_add_sgamma%2Fskills-CB3837?logo=npm&logoColor=white)](#install)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A small, growing collection of [Claude Code](https://claude.com/claude-code) skills I build and refine as I work. Each one is a focused capability the agent loads on demand — no framework, no lock-in.

Install any of them in **one command** with [`npx skills`](#install) (see below), clone and link them yourself, or use the repo as a **Claude Code plugin**.

## Skills

| Skill | Category | What it does |
|---|---|---|
| [`optimize-claude-md`](skills/engineering/optimize-claude-md/SKILL.md) | engineering | Slims a bloated `CLAUDE.md` using **progressive disclosure**: groups instructions by topic, extracts each into its own guide file, and leaves behind a compact on-demand pointer table — so the agent loads detail only when a task needs it. Ships a measurement script for before/after token counts. |
| [`checkpoint`](skills/soloterm/checkpoint/SKILL.md) | soloterm | Crystallizes the current session state into a dedicated [Solo](https://github.com/solo) scratchpad so a fresh session can resume cleanly after `/clear`. *(Requires the Solo MCP server.)* |
| [`resume`](skills/soloterm/resume/SKILL.md) | soloterm | Reads the `checkpoint` scratchpad and proposes the next steps as a clickable menu. *(Requires the Solo MCP server.)* |

> **engineering** = generally useful, ready to adopt. **soloterm** = wired to my own setup (the Solo MCP); useful as a pattern, but adapt before relying on it.

## Install

### Option A — one command with `npx skills` (easiest)

[`skills`](https://github.com/vercel-labs/skills) is an open-source installer (by Vercel Labs) that works with any GitHub repo of skills — no manual clone needed. It needs [Node.js](https://nodejs.org) (which ships `npx`).

```bash
# pick skills + agent interactively
npx skills add sgamma/skills

# just list what's inside first, without installing
npx skills add sgamma/skills --list

# install one specific skill
npx skills add sgamma/skills --skill optimize-claude-md

# install everything for Claude Code, globally, no prompts
npx skills add sgamma/skills -a claude-code -g -y
```

It symlinks (or copies) the skills into your agent's directory — `./.claude/skills/` for the current project, or `~/.claude/skills/` with `-g`. Works for Claude Code, Cursor, Codex, and ~50 other agents. Update later with `npx skills update`.

### Option B — link a local clone (for hacking on them)

```bash
git clone https://github.com/sgamma/skills.git
cd skills
./scripts/link-skills.sh    # symlinks every skill into ~/.claude/skills
```

Re-run `link-skills.sh` whenever you add or rename a skill. `./scripts/list-skills.sh` lists what's here; `./scripts/check-sync.sh` verifies the manifest and symlinks still match the folders.

### Option C — as a Claude Code plugin

Point a plugin marketplace at this repo and enable the `sgamma-skills` plugin; the skills listed in `.claude-plugin/plugin.json` become available. See the [Claude Code plugin docs](https://docs.claude.com/en/docs/claude-code/plugins).

## How it's organized

```
skills/
  engineering/   # broadly useful, shareable
  soloterm/      # Solo-MCP session workflow, tied to my own setup
scripts/
  link-skills.sh # symlink skills into ~/.claude/skills
  list-skills.sh # list skills + descriptions
  check-sync.sh  # warn if plugin.json / symlinks drift from the real folders
.claude-plugin/
  plugin.json    # plugin manifest (lists each skill path)
```

Each skill is a folder containing a `SKILL.md` (the instructions + a `description:` that tells the agent *when* to trigger it), optionally plus reference docs and helper scripts. Adding a skill = create `skills/<category>/<name>/SKILL.md`, then run `./scripts/link-skills.sh`.

## License

[MIT](LICENSE) — use them, fork them, adapt them. Attribution appreciated but not required.

---

*Repo layout and the link-skills approach are inspired by [mattpocock/skills](https://github.com/mattpocock/skills).*
