#!/usr/bin/env bash
set -euo pipefail

prefs_before=$(mktemp)
prefs_after=$(mktemp)

defaults read > "$prefs_before"
read -p "Press Enter to continue after making changes to preferences..."
defaults read > "$prefs_after"

echo "Differences:"
diff --color=always -U 20 "$prefs_before" "$prefs_after"

echo "Script executed at: $(date)"
echo "prefs_before=$prefs_before"
echo "prefs_after=$prefs_after"
echo diff --color=always -U 20 "\$prefs_before" "\$prefs_after"
