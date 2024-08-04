#!/usr/bin/env bash
set -euo pipefail

main() {
    [[ ! "$*" ]] && usage 1
    local brewfile="$1"
    
    process_formulas "$brewfile"
    process_appstore "$brewfile"
}

usage() {
    echo "Retrieve one line descriptions of each app in a brew bundle Brewfile.

Usage:
    $(basename "$0") path/to/Brewfile

Example:
    $(basename "$0") ~/.config/homebrew/Brewfile"
    exit "${1:-0}"
}

process_formulas() {
    local brewfile="$1"
    
    brew bundle list --file="$brewfile" --formula --cask | while read -r name; do
        brew desc "$name"
    done
}

process_appstore() {
    local brewfile="$1"
    local id info

    brew bundle list --file="$brewfile" --mas | while read -r name; do
        id=$(grep "$name" "$brewfile" | cut -d':' -f2 | cut -d'#' -f1 | grep -o '[0-9]*')
        info=$(mas_info "$id")
        echo "$id: $info"
    done
}

mas_info() {
    local id="$1"
    local url_local url_english
    
    url_local=$(mas info "$id" | grep "From:" | cut -d' ' -f2)
    url_english=${url_local//\/pt\//\/us\/}
    curl --silent "$url_english" | grep '<meta name="description" content="' | cut -d'"' -f4
}

main "$@"
