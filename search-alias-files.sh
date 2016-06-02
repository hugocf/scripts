#!/usr/bin/env bash
find . -type f | grep -Ev "\.([-a-zA-Z0-9]{2,20}|c|h|m)$" | grep -Ev "\.(git|sync)" | xargs -I% file % | grep --color "data$"

echo "
function stringtail {
    strings \"\$1\" | tail
}
"