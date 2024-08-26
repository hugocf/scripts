#!/usr/bin/env bash
set -euo pipefail

# See also https://github.com/yannbertrand/macos-defaults/blob/main/diff.sh

main() {
    prefs_before=$(mktemp)
    prefs_after=$(mktemp)

    save_prefs "$prefs_before"
    read -p "Press Enter to continue after making changes to preferences..."
    save_prefs "$prefs_after"

    echo "Differences:"
    diff --color=always -U 20 "$prefs_before" "$prefs_after"

    echo "Script executed at: $(date)"
    echo "prefs_before=$prefs_before"
    echo "prefs_after=$prefs_after"
    echo diff --color=always -U 20 "\$prefs_before" "\$prefs_after"
}

save_prefs() {
    check_defaults "$1"
    # check_1password "$1"
    # check_officetime "$1"
    # check_slack "$1"
    # check_things "$1"
}

check_defaults() {
    defaults read >> "$1"
    defaults -currentHost read >> "$1"
}

check_1password() {
    cat "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/Library/Application Support/1Password/Data/settings/settings.json" >> "$1"
}

check_officetime() {
    defaults read "$HOME/Library/Application Support/OfficeTime/OfficeTime Version 2 Preferences.plist" >> "$1"
}

check_slack() {
    find "$HOME/Library/Application Support/Slack" -type f | xargs -I{} stat -f "%m %N" "{}" | sort -rn >> "$1"
}

check_things() {
    defaults read /Users/hugo/Library/Group\ Containers/JLMPQHK86H.com.culturedcode.ThingsMac/Library/Preferences/JLMPQHK86H.com.culturedcode.ThingsMac.plist >> "$1"
}

main
