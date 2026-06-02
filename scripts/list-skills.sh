#!/usr/bin/env bash
set -euo pipefail

# Lists every skill in the repo, grouped by category, with its description.

REPO="$(cd "$(dirname "$0")/.." && pwd)"

find "$REPO/skills" -name SKILL.md -not -path '*/deprecated/*' | sort | while read -r skill_md; do
  rel="${skill_md#"$REPO"/skills/}"          # e.g. engineering/optimize-claude-md/SKILL.md
  category="${rel%%/*}"                        # engineering
  name="$(basename "$(dirname "$skill_md")")"  # optimize-claude-md
  # description: line under frontmatter starting with "description:"
  desc="$(sed -n 's/^description:[[:space:]]*//p' "$skill_md" | head -1 | cut -c1-100)"
  printf '%-14s %-24s %s\n' "$category" "$name" "$desc"
done
