#!/usr/bin/env bash
set -euo pipefail

full_path=$1
full_name="${full_path##*/}"    # remove path
file_name="${full_name%.*}"     # remove extension
echo "$file_name"
