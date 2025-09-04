#!/usr/bin/env bash
set -euo pipefail


# Use caller-provided HOME (mapped from host) or fall back
HOME_DIR="${HOME:-/root}"
mkdir -p "$HOME_DIR/apps"


# 1) Copy seed tools into $HOME/apps only if missing
shopt -s nullglob dotglob
for d in /opt/seed/apps/*; do
name="$(basename "$d")"
if [ ! -e "$HOME_DIR/apps/$name" ]; then
cp -r "$d" "$HOME_DIR/apps/"
fi
done


# 2) Put all tool dirs on PATH so their launchers are directly callable
for d in "$HOME_DIR"/apps/*; do
[ -d "$d" ] && PATH="$d:$PATH"
[ -d "$d/bin" ] && PATH="$d/bin:$PATH"
done
export PATH


# 3) If no args provided, drop into an interactive shell. Else exec the command.
if [ "$#" -eq 0 ]; then
exec bash
else
exec "$@"
fi
