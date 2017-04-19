#!/bin/sh
# Created by Hugo Ferreira <hugo@ferreira.cc> on 2009-04-26.
# Copyright (c) 2009 Hugo Ferreira. All Rights Reserved. 
# Licensed under the MIT License: https://opensource.org/licenses/MIT

usage() {
    echo "
FIXME: Has problems dealing with lines containing a single quote inside double quotes (see -t flag)

Usage: `basename $0` [options] file

    -c, -q      returns the citation text of the chosen quote in a new line
    -a          returns the author of the chosen quote in a new line
    -w num      wraps the line, at word level, using 'num' as the maximum column width
    -h          this usage help text

Fetches a quote line from a file, according to the current day of the year.
Permits retrieving only the \"citation\" or the \"author\" part, assuming a line
in the format:  citation - author

Example:
    `basename $0` quotes.txt
"
    exit ${1:-0}
}

# check for option errors
args=`getopt qcahw:t $*`
[[ $? != 0 ]] && usage 1

# evaluate each option
set -- $args
for i do
    case "$i" in
        -c|-q) phrase=1; shift;;
        -a) author=1; shift;;
        -w) width=$2; shift; shift;;
        -h) usage;;
        -t) debug=1; shift;;    # "undocumented" test flag: ignore file and use a default quote
        --) shift; break;;
    esac
done

# fetch the quote
if [[ $debug ]]; then
    quote="\"The quick brown fox jumped over the lazy dog, didn't it?\" - Rantanplan (the dog)"
else
    # file must exist
    file="$*"
    if [ ! -f "$file" ]; then
        echo File "$file" does not exist
        usage 1
    fi
    
    # choose a quote line from the file
    days=`expr $(date +%s) / 86400`   # epoch days
    lines=`wc -l "$file" | tr -s ' ' | cut -d' ' -f2`
    remainder=`expr $days % $lines`
    quote="`head -$remainder "$file" | tail -1 | tr -d \\\r`"
fi

# print it out
delim=" - "
if [[ $width ]]; then
    wrap="| fmt -w $width"
fi
if [[ $phrase || $author ]]; then
    [[ $phrase ]] && echo "echo \"$quote\" | awk -F'$delim' '{ print \$1 }' $wrap" | sh
    [[ $author ]] && echo "echo \"$quote\" | awk -F'$delim' '{ print \$NF }' $wrap" | sh
else
    echo "echo \"$quote\" $wrap" | sh
fi
