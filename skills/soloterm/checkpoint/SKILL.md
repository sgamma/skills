---
name: checkpoint
description: Saves the current session state into a dedicated Solo scratchpad, so that after /clear or at the start of a new day `/resume` can re-propose the next steps. Use when user is about to /clear, end the workday, or pause work mid-session.
argument-hint: "Optional: short description of what we're wrapping up (e.g. 'ADR-0009 published')"
---

<what-to-do>

Crystallize the current work state into a dedicated Solo scratchpad, so that a new session (post-`/clear` or the next day) can be resumed with `/resume` without asking the user to remember what was going on.

## Step 1 — Identify the current Solo proj

Call `mcp__solo__whoami` to get `project_id` + `project_name`. The whole checkpoint is scoped to the current proj.

## Step 2 — Automatically extract the state from the conversation

Draft a summary by looking at the recent conversation:

- **What was wrapped up in this session**: 1-2 sentences on decisions, artifacts, problems solved
- **Crystallized decisions**: compact bullet list (e.g. published ADRs, design choices, settled configurations)
- **Files changed or created**: path + 1-line description (no diff)
- **Prioritized next steps** (3-5 max, in order): explicit action + 1-line context. Include cross-proj ones if relevant ("proj/8: ...").
- **Starting command** (a ready-to-paste prompt): e.g. "read the checkpoint and let's continue with [step 1]"

The skill's optional argument, if passed, is the theme of the wrap-up (e.g. "ADR-0009 published") — use it to orient the extraction.

## Step 3 — Confirm with AskUserQuestion (hybrid mode)

Show the compact draft in chat (not a giant dump — keep it concise). Then `AskUserQuestion` with options:
- "Save as is" (proceed to step 4)
- "I'll edit it" (open mental editor: ask the user to write free-form corrections and recompose)
- "Cancel" (exit without writing)

## Step 4 — Write to the dedicated Solo scratchpad

Scratchpad name: **`checkpoint`** (scope implicit from the current proj). Tags: `["checkpoint", "next-step"]`.

Use `mcp__solo__scratchpad_write` (intentional overwrite — the checkpoint is ALWAYS the latest state, not a cumulative log). Exact body format:

```markdown
# Checkpoint — {project_name} — {YYYY-MM-DD HH:MM}

## Status
{1-2 sentence summary of what was wrapped up}

## Crystallized decisions
- {bullet 1}
- {bullet 2}
- ...

## Files changed or created
- `{path}` — {1-line description}
- ...

## Next steps (in order)
1. **{concise action}** — {context}
2. **{concise action}** — {context}
3. ...

## Starting command after /clear

\`\`\`
{ready-to-paste prompt}
\`\`\`

## Cross-proj notes (optional)
- proj/{N} {name}: {short note}
- ...
```

If the `mcp__solo__scratchpad_write` tool isn't available, run `ToolSearch` to load it. Same goes for `scratchpad_find` (check whether a `checkpoint` scratchpad already exists; if so, overwrite via its id; if not, create a new one).

## Step 5 — Confirm to the user

One line: "Saved. When you reopen the session, invoke `/resume` (or paste the starting command directly)."

</what-to-do>

<supporting-info>

## Important convention

- **Overwrite, not append**: the `checkpoint` scratchpad ALWAYS represents the latest state. It doesn't accumulate. The historical narrative lives in `*session-progress*`, here only the current snapshot.
- **Concise**: 30-40 lines total max. The scratchpad is a context spillover for `/resume`, not yet another doc to maintain.
- **No PII / secrets**: redact API keys, passwords, plaintext credentials. If you find anything suspicious in the conversation, replace it with `<redacted>`.

## When NOT to use checkpoint

- Sessions where no substantial work happened (5 messages, no decisions)
- Sessions where you just committed and pushed (the commit message + session-progress scratchpad are already the state)
- Purely exploratory sessions (reading code without decisions)

In these cases, tell the user there's no need for a checkpoint and suggest a possible alternative (e.g. "the commit you just made + the session-progress scratchpad are enough as state").

## Difference vs /handoff (built-in skill)

`/handoff` produces a generic doc for "another agent". `/checkpoint` is specific to the Stefano + Solo MCP workflow: the state lives in a Solo scratchpad accessible cross-machine, is single-state (overwrite), and is designed for the `/checkpoint` → `/clear` → `/resume` pair.

If the user wants to hand the work off to another person/agent, suggest `/handoff`. If they want to suspend their own work to resume it later, `/checkpoint` is the right choice.

</supporting-info>
