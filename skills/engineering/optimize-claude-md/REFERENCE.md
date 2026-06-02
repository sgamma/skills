# Reference — Template & Heuristics

## Classification

Decide CORE (inline) vs TOPIC (extract) per block.

**Keep as CORE — loaded every session:**
- A one-paragraph project/stack snapshot (language, framework, key libs, architecture in a sentence).
- Non-negotiable guardrails that, if violated, break things — but compressed to **one line each**
  with a pointer to the guide for the why (e.g. "Use JDBI, not JPA — see PERSISTENCE_JDBI_DAO.md").
- The on-demand pointer table itself + the auto-reference instruction.
- Anything a contributor needs for *literally any* task in the repo.

**Move to a TOPIC guide — loaded on demand:**
- Build / run / test / deploy recipes and command lists.
- Persistence, schema, SQL, migration details.
- Per-feature or per-domain implementation guides.
- External integrations (auth/SSO, cloud, third-party APIs).
- Anything that only matters for a subset of tasks, or that's long (a code block, a table, a checklist).

**Tie-breakers:**
- If a block is > ~10 lines and task-specific → extract.
- If you'd only read it when doing one kind of work → extract.
- If removing it would make *every* task riskier → keep inline (compressed).
- When genuinely unsure → extract; the pointer keeps it one Read away.

## CLAUDE.md output template

```markdown
# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

This file is intentionally lean. Detailed guidance lives in `<guides-dir>/` and is loaded
**on demand** — read the matching guide only when your task touches its topic (progressive disclosure).

## Project Snapshot

<one short paragraph: language, framework version, architecture in a sentence>

<optional: a compact bullet list of modules / core stack — keep it tight>

## 🚨 Non-negotiable

<one line per hard rule + pointer to the guide that explains it. Omit the section if there are none.>

## On-demand guides

Read the matching guide when your task involves its topic — do not load them all upfront.

| When the task involves… | Read |
|---|---|
| <concrete trigger: DAOs, SQL, migrations…>      | [`<guides-dir>/PERSISTENCE_JDBI_DAO.md`](<guides-dir>/PERSISTENCE_JDBI_DAO.md) |
| <concrete trigger: building, running, testing…> | [`<guides-dir>/BUILD_RUN_TEST.md`](<guides-dir>/BUILD_RUN_TEST.md) |
| <concrete trigger…>                             | [`<guides-dir>/<TOPIC>.md`](<guides-dir>/<TOPIC>.md) |

### Auto-reference pattern

When a task's context matches a guide's topic above: **read the relevant guide first**, apply
its methodology, and adapt its patterns to the specific domain. This keeps implementations
consistent without loading every guide into context up front.
```

Make each "When the task involves…" cell a concrete trigger (keywords, file types, domain
terms) — that is what tells Claude *when* to open the guide. Vague triggers ("misc", "other")
defeat the purpose.

## Guide file template

Each extracted guide opens with a callout so a reader landing on it knows the scope:

```markdown
# <Human Title>

> Read this guide when <the concrete situation — e.g. "writing or modifying any database
> access code (DAO, SQL, connection pools, Liquibase changelogs)">.

<the extracted content, verbatim — headings, code blocks, tables preserved>
```

Naming: match the repo's existing convention. If guides already exist in
`SCREAMING_SNAKE_CASE.md`, follow it; otherwise that's a good default. Keep names
topic-inherent (`PERSISTENCE_JDBI_DAO.md`, not `GUIDE_1.md`).

## Conflict & safety rules

- **Never summarize content out of existence.** Extraction is a *move* — the guide gets the
  full text. Compression happens only to the inline guardrails that point at it.
- **Existing guide file?** Show the user the conflict. Offer: merge new content under a new
  heading, or pick a different filename. Don't silently overwrite.
- **Cross-references:** if extracted content references another extracted topic, link it with a
  relative path between guides so the chain stays navigable.
- **Verify links:** after writing, every `[...](path)` in CLAUDE.md and the guides must resolve.

## Reporting the result

After extraction, show a concise before/after:

```
CLAUDE.md:  180 lines / ~6.0k tok  →  42 lines / ~1.4k tok   (−77%)
Extracted:  5 guides, ~4.6k tok total, loaded only on demand
```

Use `scripts/measure.sh CLAUDE.md` for the before number and again for the after; pass all the
new guide paths to it to total their size.
