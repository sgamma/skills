#!/usr/bin/env bash
set -euo pipefail

# Verifies the repo is internally consistent. Three checks:
#   1. plugin.json  <->  real skill folders (skills/*/*/SKILL.md)
#   2. ~/.claude/skills symlinks  <->  real skill folders
#   3. duplicate skill folder names (their symlinks would collide)
#
# Exit code 0 = in sync, 1 = divergence found (suitable for a pre-commit hook).

REPO="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN="$REPO/.claude-plugin/plugin.json"
DEST="$HOME/.claude/skills"

problems=0
note() { printf '  \033[33m⚠\033[0m %s\n' "$1"; problems=$((problems + 1)); }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$1"; }

# --- gather real skills on disk (path relative to repo, e.g. ./skills/engineering/foo)
disk_paths="$(
  find "$REPO/skills" -name SKILL.md -not -path '*/deprecated/*' -print0 |
  while IFS= read -r -d '' f; do d="$(dirname "$f")"; echo "./${d#"$REPO"/}"; done | sort -u
)"

# === Check 1: plugin.json <-> disk ===========================================
echo "plugin.json <-> skill folders"
if [ ! -f "$PLUGIN" ]; then
  note "manifest mancante: $PLUGIN"
else
  manifest_paths="$(grep -oE '"\./skills/[^"]+"' "$PLUGIN" | tr -d '"' | sed 's:/*$::' | sort -u)"

  while IFS= read -r p; do
    [ -z "$p" ] && continue
    grep -qxF "$p" <<<"$manifest_paths" || note "su disco ma assente da plugin.json: $p"
  done <<<"$disk_paths"

  while IFS= read -r p; do
    [ -z "$p" ] && continue
    [ -f "$REPO/${p#./}/SKILL.md" ] || note "in plugin.json ma senza SKILL.md su disco: $p"
  done <<<"$manifest_paths"
fi
[ "$problems" -eq 0 ] && ok "manifest allineato"

# === Check 2: ~/.claude/skills symlinks <-> disk =============================
echo "~/.claude/skills symlinks <-> skill folders"
before=$problems
while IFS= read -r p; do
  [ -z "$p" ] && continue
  src="$REPO/${p#./}"
  name="$(basename "$src")"
  link="$DEST/$name"
  if [ ! -e "$link" ] && [ ! -L "$link" ]; then
    note "symlink mancante: $name  (esegui scripts/link-skills.sh)"
  elif [ -L "$link" ] && [ ! -e "$link" ]; then
    note "symlink rotto: $name -> $(readlink "$link")  (esegui scripts/link-skills.sh)"
  elif [ "$(cd "$(dirname "$link")" && readlink "$link")" != "$src" ] && [ "$(readlink -f "$link" 2>/dev/null || true)" != "$src" ]; then
    note "symlink punta altrove: $name -> $(readlink "$link")"
  fi
done <<<"$disk_paths"
[ "$problems" -eq "$before" ] && ok "symlink allineati"

# === Check 3: duplicate skill folder names ===================================
dupes="$(while IFS= read -r p; do basename "$p"; done <<<"$disk_paths" | sort | uniq -d)"
if [ -n "$dupes" ]; then
  echo "nomi skill duplicati (i symlink collidono)"
  while IFS= read -r d; do [ -n "$d" ] && note "nome duplicato: $d"; done <<<"$dupes"
fi

echo ""
if [ "$problems" -eq 0 ]; then
  printf '\033[32mIn sync.\033[0m\n'
else
  printf '\033[33m%d problema/i trovati.\033[0m\n' "$problems"
  exit 1
fi
