#!/usr/bin/env bash
# Measure markdown file size: lines, chars, and an estimated token count (chars/4).
# Use to capture a CLAUDE.md baseline before extraction and the after-state once done.
#
# Usage:
#   measure.sh                       # measures ./CLAUDE.md
#   measure.sh CLAUDE.md             # one file
#   measure.sh CLAUDE.md docs/operational-guides/*.md   # many files + a TOTAL row
set -euo pipefail

[ "$#" -eq 0 ] && set -- CLAUDE.md

total_chars=0
counted=0

for file in "$@"; do
  if [[ ! -f "$file" ]]; then
    printf 'skip (not found): %s\n' "$file" >&2
    continue
  fi
  chars=$(wc -c < "$file" | tr -d ' ')
  lines=$(wc -l < "$file" | tr -d ' ')
  tokens=$(( chars / 4 ))
  printf '%-52s %6s lines  %8s chars  ~%7s tok\n' "$file" "$lines" "$chars" "$tokens"
  total_chars=$(( total_chars + chars ))
  counted=$(( counted + 1 ))
done

if [[ "$counted" -gt 1 ]]; then
  printf '%-52s %6s        %8s chars  ~%7s tok\n' "TOTAL ($counted files)" "" "$total_chars" "$(( total_chars / 4 ))"
fi
