#!/usr/bin/env bash

# Created by Hugo Ferreira <hugo@ferreira.cc> on 2016-02-06
# Licensed under the MIT License: https://opensource.org/licenses/MIT
readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from

# Script configuration
readonly DEFAULT_EMAIL=$(git config --global user.email)

# Script functions
function usage () {
    echo "
Fetches the latest changes from all the git repos in a folder and
makes sure the correct email address is configured in each repo.

Usage:
    $(basename $0) [options] folder email   

    -h          this usage help text
    folder      the parent folder of the repos to update [default current folder]
    email       the author email to set in the commits

Example:
    $(basename $0) \$WORK_CODE work@example.com"
    exit ${1:-0}
}

function ask_if_empty () {
    local value="$1"
    local default="$2"
    local message="$3"
    local options="$4"  # pass "-s" for passwords
    if [[ -z "$value" ]]; then
        read $options -p "$message [$default] " value
    fi
    value=$(echo ${value:-$default})
    echo "$value"
}

function update_repo {
    local repo="$1"
    local email="$2"
    local origin=$(pwd)
    cd "$repo"
    show_header "$repo"
    set_repo_email "$email"
    sync_with_remote 2>&1 | 
        GREP_COLOR='01;31' grep --color=always -E 'error|$' | 
        GREP_COLOR='01;32' grep --color=always -E "Your branch is ahead|$" | 
        GREP_COLOR='01;33' grep --color=always -E "Your branch is behind|$"
    cd "$origin"
}

function show_header {
    local repo="$1"
    echo
    echo $'\e[1;34m'"$repo"$'\e[0m' # color = blue
}

# Makes sure there is an email set for the repo. Prompts for it if needed.
function set_repo_email {
    local email="$1"
    local existing="$(git config --local user.email)"
    local new_email=""
    if [[ "$email" && -z "$existing" ]]; then
        # Just set new email
        new_email="$email"
        
    elif [[ "$email" && "$existing" && "$email" != $existing ]]; then
        # Override existing email?
        override=$(ask_if_empty "" "n" "Override current repo email $existing (y/n)?")
        [[ "$override" =~ ^[yY]$ ]] && new_email="$email"
        
    elif [[ -z "$email" && -z "$existing" ]]; then
        # Ask for an email to set?
        email=$(ask_if_empty "" "$DEFAULT_EMAIL" "Repo email is missing. What email to use in this repo?")
        new_email="$email"
    fi
    
    if [[ "$new_email" ]]; then
        echo "Setting repo email to $new_email"
        git config user.email $new_email
    fi
}

function sync_with_remote {
    # autostash is only available since git version 2.9
    # for earlier versions use: git config --global rebase.autoStash true
    local version=$(git --version | cut -d' ' -f3)
    local autostash=$([[ $version < 2.9 ]] && echo "" || echo "--autostash")
    
    git fetch --all --prune
    git checkout master
    git pull --rebase $autostash
}

# Parse command line options
while getopts abn:h option; do
    case $option in
        h) usage ;;
        \?) usage 1 ;;
    esac
done
shift $(($OPTIND - 1));     # take out the option flags

# Validate input parameters
folder=${1:-.}
email="$2"

# Do the work (tweak IFS to handle folders with spaces)
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for repo in $(find "$folder" -name .git | grep -v .terraform | xargs -I{} dirname "{}"); do
    time update_repo "$repo" "$email"
done
IFS=$SAVEIFS
