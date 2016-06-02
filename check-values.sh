#!/usr/bin/env bash
readonly STATUS_SUCCESS=0  # exit status for commands

# Script functions
function usage () {
    echo "
Usage: $(basename $0) values_file target_file

    values_file     list of values to search on the target_file, one per line
    target_file     the file where to search for matching values

Example:
    $(basename $0) ids.txt server.log
    
Note:
    Consider also a more simplistic approach
    grep -f values_file target_file"
    exit ${1:-0}
}

# Exit and show help if wrong command line parameters
[ $# != 2 ] && usage 1

# Do the work
source_file=$1
target_file=$2

for val in `cat $source_file`
do
    grep --color --max-count=1 -E "^$val" $target_file
    [ $? != $STATUS_SUCCESS ] && echo "$val: Values not found in file '$(basename $target_file)'"
done
