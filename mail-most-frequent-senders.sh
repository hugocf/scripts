#!/usr/bin/env bash

echo "Filter and group most frequent senders from an exported list of *.eml mail messages from macOS Mail app:"
folder=${1:-.}

grep "^From:" $folder/*.eml | sed -E 's|.*<(.*)>.*|\1|g' > $folder/senders.txt
sort $folder/senders.txt | uniq -c | sort -nr | head -40
