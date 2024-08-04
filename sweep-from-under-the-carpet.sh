#!/usr/bin/env bash

# Created by Hugo Ferreira <hugo@ferreira.cc> on 2012-12-22.
# Copyright (c) 2012 Mindclick (http://mindclick.info). All Rights Reserved.
# Licensed under the MIT License: https://opensource.org/licenses/MIT
readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from

# Script configuration
readonly DEFAULT_SOURCE=~/Desktop/Backlog/
readonly DEFAULT_TARGET=~/Desktop

# Script functions
usage() {
    echo "
Usage: `basename $0` [options] folders

    -h          this usage help text
    folders     list of backlog folders

Moves the file at the top of a backlog folder into $DEFAULT_TARGET for further processing.
Example:
    `basename $0` $DEFAULT_SOURCE"
    exit ${1:-0}
}

askifempty() {
    ask_val="$1"; ask_default="$2"; ask_msg="$3"; ask_options="$4"  # pass "-s" for passwords
    if [[ -z "$ask_val" ]]; then
        read $ask_options -p "$ask_msg [$ask_default] " ask_val
    fi
    ask_val=$(echo ${ask_val:-$ask_default})
    echo "$ask_val"
}

# Exit and show help if the command line is empty
[[ ! "$*" ]] && usage 1

# Parse command line options
while getopts h option; do
    case $option in
        h) usage ;;
        \?) usage 1 ;;
    esac
done
shift $(($OPTIND - 1));     # take out the option flags

# Validate input parameters
[[ ! "$*" ]] && usage 1     # not going to interactively ask for the list of folders
target=$DEFAULT_TARGET

# Do the work
for folder in "$@"; do
    if [ -d "$folder" ]; then
        topfile=`ls -1 "$folder" | head -1`
        [[ "$topfile" ]] && mv "$folder/$topfile" "$target"
    fi
done
