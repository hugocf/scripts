#!/usr/bin/env bash
set -euo pipefail

# See `things.sh` for inspiration
id="${1:-}"
db="$(find ~/Library/Group\ Containers/JLMPQHK86H.com.culturedcode.ThingsMac -name 'main.sqlite' | head -1)"

task="
    select
        datetime(creationDate, 'unixepoch', 'localtime') as creationDate,
        datetime(userModificationDate, 'unixepoch', 'localtime') as modificationDate,
        datetime(stopDate, 'unixepoch', 'localtime') as stopDate,
        title
    from TMTask
    where uuid = '$id';"

checklist="
    select
        datetime(creationDate, 'unixepoch', 'localtime') as creationDate,
        datetime(userModificationDate, 'unixepoch', 'localtime') as modificationDate,
        datetime(stopDate, 'unixepoch', 'localtime') as stopDate,
        title
    from TMChecklistItem
    where task = '$id'
    order by \"index\";
"

sqlite3 "$db" "$task $checklist"
