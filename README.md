# Claude Code Skills

A small, growing collection of [Claude Code](https://claude.com/claude-code) skills I build and refine as I work. Each one is a focused capability the agent loads on demand — no framework, no lock-in. Clone it, link it, make it your own.

The repo doubles as a **Claude Code plugin** (`.claude-plugin/plugin.json`), so you can install the whole set at once or cherry-pick individual skills.

## Skills

| Skill | Category | What it does |
|---|---|---|
| [`optimize-claude-md`](skills/engineering/optimize-claude-md/SKILL.md) | engineering | Slims a bloated `CLAUDE.md` using **progressive disclosure**: groups instructions by topic, extracts each into its own guide file, and leaves behind a compact on-demand pointer table — so the agent loads detail only when a task needs it. Ships a measurement script for before/after token counts. |
| [`checkpoint`](skills/personal/checkpoint/SKILL.md) | personal | Crystallizes the current session state into a dedicated [Solo](https://github.com/solo) scratchpad so a fresh session can resume cleanly after `/clear`. *(Requires the Solo MCP server.)* |
| [`resume`](skills/personal/resume/SKILL.md) | personal | Reads the `checkpoint` scratchpad and proposes the next steps as a clickable menu. *(Requires the Solo MCP server.)* |

> **engineering** = generally useful, ready to adopt. **personal** = wired to my own setup (e.g. the Solo MCP); useful as a pattern, but adapt before relying on it.

## Install

### Option A — link a local clone (simplest)

```bash
git clone https://github.com/sgamma/claude-skills.git
cd claude-skills
./scripts/link-skills.sh    # symlinks every skill into ~/.claude/skills
```

Re-run `link-skills.sh` whenever you add or rename a skill. To see what's installed:

```bash
./scripts/list-skills.sh
```

### Option B — as a Claude Code plugin

Point a plugin marketplace at this repo and enable the `sgamma-skills` plugin; the skills listed in `.claude-plugin/plugin.json` become available. See the [Claude Code plugin docs](https://docs.claude.com/en/docs/claude-code/plugins).

## How it's organized

```
skills/
  engineering/   # broadly useful, shareable
  personal/      # tied to my own tooling/workflow
scripts/
  link-skills.sh # symlink skills into ~/.claude/skills
  list-skills.sh # list skills + descriptions
.claude-plugin/
  plugin.json    # plugin manifest (lists each skill path)
```

Each skill is a folder containing a `SKILL.md` (the instructions + a `description:` that tells the agent *when* to trigger it), optionally plus reference docs and helper scripts. Adding a skill = create `skills/<category>/<name>/SKILL.md`, then run `./scripts/link-skills.sh`.

## License

[MIT](LICENSE) — use them, fork them, adapt them. Attribution appreciated but not required.

---

*Repo layout and the link-skills approach are inspired by [mattpocock/skills](https://github.com/mattpocock/skills).*
