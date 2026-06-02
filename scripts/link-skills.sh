#!/usr/bin/env bash
set -euo pipefail

# Symlinks every skill in this repo into ~/.claude/skills so the local
# Claude Code CLI picks them up. Re-run after adding or renaming a skill.
#
# Adapted from mattpocock/skills (MIT).

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="$HOME/.claude/skills"

# If ~/.claude/skills is itself a symlink that resolves into this repo, the
# per-skill links below would be written back into the repo's own tree.
# Detect and bail out instead of polluting the working copy.
if [ -L "$DEST" ]; then
  resolved="$(readlink "$DEST")"
  case "$resolved" in
    "$REPO"|"$REPO"/*)
      echo "error: $DEST is a symlink into this repo ($resolved)." >&2
      echo "Remove it (rm \"$DEST\") and re-run; it will be recreated as a real dir." >&2
      exit 1
      ;;
  esac
fi

mkdir -p "$DEST"

find "$REPO/skills" -name SKILL.md -not -path '*/deprecated/*' -print0 |
while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  target="$DEST/$name"

  # Replace a stale real dir, but never clobber an unrelated symlink silently.
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    rm -rf "$target"
  fi

  ln -sfn "$src" "$target"
  echo "linked $name -> $src"
done
