#!/usr/bin/env bash

# Created by Hugo Ferreira <hugo@mindclick.info> on 2010-06-02.
# Copyright (c) 2010 Mindclick. All Rights Reserved.
# Licensed under the MIT License: https://opensource.org/licenses/MIT

usage() {
    echo "Usage: `basename $0` [options] csvfile

Splits a csv file, preserving the header in each one of the split files.

Options:
    -l num      the number of line to split the file into [default: 500]
"
    if [[ $1 != "" ]]; then
        echo $1
        code=1
    fi
    exit ${code:-0}
}

# validate params
args=`getopt l: $*`
[[ $? != 0 ]] && usage "Error: received an invalid option"
set -- $args
for i do
    case "$i" in
        -l) numlines=$2; shift; shift;;
        --) shift; break;;
    esac
done
[[ $# != 1 ]] && usage "Error: Mandatory file name is missing"
file="$1"
[[ ! -f "$file" ]] && usage "Error: File '$file' does not exist"
numlines=${numlines:-500}

# prepare definitions
TIMESTAMP=`date "+%Y%m%d%H%M%S"`-$$
BASENAME=`basename $file | sed 's/\(.*\)\..*/\1/'`
EXTENSION=`basename $file | sed 's/.*\.\(.*\)/\1/'`
DATA=$BASENAME-data-$TIMESTAMP
HEADER=$BASENAME-header-$TIMESTAMP
SPLITS=$BASENAME-split-$TIMESTAMP-

# process the file
echo "Splitting '$file' in $numlines lines chunks"
cp -p $file $DATA
head -1 $DATA > $HEADER
sed -e '1d' -i '' $DATA
split -a4 -l$numlines $DATA $SPLITS
ls ${SPLITS}* 2> /dev/null | xargs -I% echo "cat $HEADER % > %.$EXTENSION" | sh
rm -f $DATA $HEADER ${SPLITS}????
ls -l $SPLITS* 2> /dev/null
