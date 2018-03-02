#!/usr/bin/env bash

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from

readonly REPOS_FOLDER=.
readonly STATS_FOLDER=stats

list_repos () {
    # seek folders with .git inside; 
    # exclude .whatever folders in the path
    find $REPOS_FOLDER -name .git -type d -exec dirname {} \; | grep -v '/\.[a-z]*/'
}

stat_repos () {
    local repos=$*
    for r in $repos; do
        stats_file=$(convert_repo_to_stats $r)
        mkdir -p $(dirname $stats_file)
        echo Processing $r
        gitinspector -HTmlr -f '**' --format=html $r > $stats_file
    done
}

convert_repo_to_stats () {
    local repo=$1
    echo $r | sed -e "s|$REPOS_FOLDER/|$STATS_FOLDER/|" -e 's|$|\.html|'
}

cd "$CALLDIR"
stat_repos $(list_repos)
