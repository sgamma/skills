---
name: optimize-claude-md
description: Slim a bloated CLAUDE.md by applying progressive disclosure — group instructions by topic, extract each topic into its own named guide file, and replace the bulk with an on-demand pointer table so Claude loads detail only when a task needs it. Use when CLAUDE.md (or AGENTS.md / agent context files) is too long, consumes too much context at startup, when the user mentions "slim/shrink/split CLAUDE.md", "reduce startup context", or "load instructions on demand".
---

# Optimize CLAUDE.md (Progressive Disclosure)

## What this does

A long CLAUDE.md is loaded into context on **every** session start, whether or not the
task touches its contents. This skill restructures it so only a small always-relevant
**core** stays inline, and every detailed topic moves into its own guide file that Claude
reads **on demand** — pointed to by a compact table. Net effect: smaller startup context,
same knowledge available when needed.

Goal shape (see [REFERENCE.md](REFERENCE.md) for the full template):
- **CLAUDE.md** → project snapshot + non-negotiable guardrails + an on-demand pointer table (~30–60 lines)
- **`docs/operational-guides/<TOPIC>.md`** → one file per topic, each opening with a `> read this when…` callout

## Workflow (propose, then extract)

1. **Measure the baseline.** Run the bundled script on the target file:
   `bash scripts/measure.sh CLAUDE.md` — record lines / chars / ~tokens.
2. **Read & segment.** Read the whole CLAUDE.md. Break it into coherent instruction blocks
   (usually one per `##`/`###` heading or topic cluster).
3. **Classify each block** as **CORE** (stays inline) or **TOPIC** (moves to a guide).
   Heuristics in [REFERENCE.md](REFERENCE.md#classification). When unsure, lean toward moving it.
4. **Group TOPIC blocks** into a small number of coherent guides and pick a topic-named
   filename for each (match the project's existing convention; default `SCREAMING_SNAKE_CASE.md`).
5. **Detect the guides directory.** Reuse an existing one (`docs/operational-guides/`,
   `docs/`, `.claude/guides/`) if present; otherwise propose `docs/operational-guides/`.
6. **PROPOSE and STOP.** Present a table — `topic → target file → source sections → est. size` —
   plus what will remain in CLAUDE.md. Wait for the user's approval before writing anything.
7. **On approval, extract** (content is **moved verbatim, never summarized away**):
   - Create each guide file: a `# Title`, a `> read this guide when …` callout, then the
     extracted content. Merge/warn if the file already exists; never silently overwrite.
   - Rewrite CLAUDE.md from the template: keep CORE, add the pointer table + auto-reference
     instruction, link every guide with a relative path.
8. **Verify.** Re-run `scripts/measure.sh` on CLAUDE.md (and on the guides) and report the
   before/after. Confirm every original instruction now lives somewhere (no information lost)
   and every guide link resolves.

## What stays vs. what moves

| Stays in CLAUDE.md (CORE)                                  | Moves to a guide (TOPIC)                                  |
|-----------------------------------------------------------|----------------------------------------------------------|
| One-paragraph project/stack snapshot                      | Step-by-step how-tos, build/run/test recipes             |
| Non-negotiable guardrails (1 line each + pointer)         | Domain deep-dives, schema/SQL details, API integrations  |
| The on-demand pointer table + auto-reference rule         | Anything only relevant to a subset of tasks              |

A guardrail pattern: keep the *rule* inline as one line, push the *explanation* into the guide
(e.g. "Persistence is JDBI, **not** JPA — read PERSISTENCE_JDBI_DAO.md before touching a DAO").

## Notes

- This is a **moving** refactor: extraction must not drop content. If a block is genuinely
  obsolete, call it out for deletion separately — don't quietly discard it.
- Never delete or overwrite an existing guide without showing the user the conflict first.
- Keep CLAUDE.md scannable: the pointer table is the load-bearing part — make each row's
  "when the task involves…" trigger concrete so Claude knows exactly when to open the guide.

Full output template and classification heuristics: **[REFERENCE.md](REFERENCE.md)**.
