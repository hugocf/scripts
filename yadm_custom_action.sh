#!/usr/bin/env bash
set -euo pipefail

check_changes() {
    yadm status --porcelain | cut -c4- | while read -r filename; do
        if [[ "$filename" == *.plist && "$(file --brief --mime "$filename")" == application/octet-stream* ]]; then
            pl2xml "$filename"
        fi
    done
    yadm diff --color-words
}

pl2xml() {
    local bin="$1"
    local xml="$1.xml"

    cp "$bin" "$xml"
    plutil -convert xml1 "$xml"
    echo "Converted copy to xml in $xml"
}

restore_unstaged_plist() {
    yadm status --porcelain | grep "^.[M?].*plist.*" | cut -c4- | xargs -I{} yadm restore {}
}

case ${1:-} in
    check) check_changes ;;
    noplist) restore_unstaged_plist ;;
    *) echo "Please choose a valid command: check, noplist" ;;
esac
