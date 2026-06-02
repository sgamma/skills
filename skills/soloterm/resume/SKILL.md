---
name: resume
description: Reads the current proj's `checkpoint` Solo scratchpad (created by `/checkpoint` in a previous session) and proposes the next steps as a clickable menu. Use when starting a fresh session after /clear or at the beginning of a new workday.
---

<what-to-do>

Resume a previous work session by reading the current proj's Solo checkpoint and presenting the next steps in an immediately actionable way.

## Step 1 — Identify the current Solo proj

Call `mcp__solo__whoami` for `project_id` + `project_name`.

## Step 2 — Read the `checkpoint` scratchpad

Look for a scratchpad named `checkpoint` (exact name) in the current proj via `mcp__solo__scratchpad_find` with scope=headings over another scratchpad, or more directly: `mcp__solo__scratchpad_list` filtered by tag `["checkpoint"]`, or `scratchpad_find` by name.

### Fallback if it doesn't exist

If there's no `checkpoint` scratchpad for the current proj:
- Look for a scratchpad whose name contains `session-progress` or `progress` as a fallback
- If one exists, read the LAST `## Snapshot` section and propose: "There's no dedicated checkpoint, but there is a progress narrative. Want me to read the latest snapshot and extract the next steps from it?"
- If the user confirms → proceed as in Step 3 but over that content

If there's no narrative either → "No previous state found for proj `{name}`. Want to start a fresh session? What are you about to do?"

## Step 3 — Show a short summary

In chat (do NOT dump the raw scratchpad):

```
Resuming {project_name} from the checkpoint of {date}.

Status: {first sentence of Status}.

Accumulated decisions: {decisions in 1 line}.

Files touched: {short list}.
```

Ten lines max. Density matters: the user should be able to grasp the context in 5 seconds of reading.

## Step 4 — Propose the next steps as a menu

Use `AskUserQuestion` with the checkpoint's next steps as clickable options (max 4):

- Question: "Which next step do you want to start from?"
- Header: "Next step"
- Options: each next step becomes an option (label = concise action, description = context)

If there are > 4 next steps, take the top 4 in order and add a note "+ N minor steps in the scratchpad".

## Step 5 — Execute the chosen step

Once the user clicks an option:
- Store the choice in the current context
- Proceed with the action: invoke the skill suggested in the checkpoint (e.g. `/to-issues`, `/tdd`), or start the analysis/implementation directly
- If the checkpoint has a "Starting command after /clear" and the user picks "everything, follow the starting command" → follow that textual instruction

</what-to-do>

<supporting-info>

## Important convention

- **Read-only on the checkpoint**: `/resume` reads but does NOT delete the checkpoint scratchpad. It survives across sessions until it's explicitly overwritten by a new `/checkpoint`.
- **Don't duplicate the read**: if the user has already read the scratchpad in conversation or already said what to do, don't re-run `/resume`. The skill is an entry point, not a loop.
- **Cross-proj**: if the current proj's checkpoint mentions tasks in other projs (`proj/8: ...`), propose that the user re-run `/resume` after switching project, or spawn a Solo agent in the other proj for the specific task.

## Expected behavior

- Latency: ~3 tool calls (whoami + scratchpad_list/find + scratchpad_read). Fast.
- User-visible output: ~10-15 lines + AskUserQuestion. Not a dump.
- Outcome: the user clicks an option and gets going. NO further grilling — the checkpoint was the moment to decide; `/resume` is the moment to execute.

## Difference vs manually reading the session-progress scratchpad

The user can always type "read mail42-session-progress and let's continue with X". `/resume` is the automated version that:
- Autonomously finds the right checkpoint for the current proj
- Extracts only the relevant state (not the entire narrative)
- Presents a clickable choice, not free-form text

It's worth invoking even if the user "vaguely remembers": the clickable menu removes the "forgot a detail" factor.

</supporting-info>
