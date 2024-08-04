#!/bin/sh
readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from

# Colors
readonly BOLD="\033[1m"
readonly INVERT="\033[7m"
readonly NORMAL="\033[0m"

# Script functions
test_case() {
    echo "$BOLD$INVERT\n => $1: $NORMAL";
}

validation() {
    echo "\n${BOLD}Validation:$NORMAL";
}

highlight() {
    awk -v good="$1" -v bad="$2" -v normal="$NORMAL" '{
        sub(good, "\033[1;34m" "&" normal)
        sub(bad,  "\033[1;31m" "&" normal)
        print
    }'
}

highlight_diff() {
    highlight "identical" "differ"
}

alias compare="diff -s -q -w"

# Do the work
test=../bash.sh
cd $BASEDIR

test_case "What should happen"
echo; $test "something" | highlight "something" "another thing"

test_case "What should happen"
echo; $test "something" | highlight "something" "another thing"
validation
compare /dev/null /dev/null | highlight_diff
