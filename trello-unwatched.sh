#!/usr/bin/env bash

set -u  # treat unset variables as errors

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly ENVFILE=$(basename ${0%.*}).env
readonly APIBASE="https://api.trello.com/1"

usage () {
    echo "Show a list of a team’s Trello boards that are not being watched.

Usage:
    $(basename $0) team_slug"
    exit ${1:-0}
}

header () {
    local msg=$*
    echo
    echo "$msg"
}

list_unwatched_open_boards () {
    local team=$1
    curl --silent "$APIBASE/organizations/$team/boards?filter=open&fields=url,subscribed&key=$TRELLO_API_KEY&token=$TRELLO_API_TOKEN" \
        | jq --raw-output '.[] | select(.subscribed == false) | .url'
    if [[ $? != 0 ]]; then
        echo Error: $(curl --silent "$APIBASE/organizations/$team/?key=$TRELLO_API_KEY&token=$TRELLO_API_TOKEN")
    fi
}

# Exit with usage if no params received
[[ ! "$*" ]] && usage 1
team=$1

header "Checking team:"
echo "https://trello.com/$team"

header "Reading API Keys & Tokens:"
echo "$BASEDIR/$ENVFILE"
source $BASEDIR/$ENVFILE

header "Unwatched boards:"
list_unwatched_open_boards $team
echo "—//—"
