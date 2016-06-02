#!/bin/sh
# Created by Hugo Ferreira <hugo@ferreira.cc> on 2009-04-22.
# Copyright (c) 2009 Hugo Ferreira. All Rights Reserved. 
# Licensed under the BSD License: http://creativecommons.org/licenses/BSD

if [ $# -lt 1 ]; then
echo << EOF "
Usage: `basename $0` "file1" "file2" ...

Grabs all lines starting with "http" from the submitted files
and triggers a web request for that url, dumping the content away.

Example: `basename $0` *.txt
"
EOF
fi

for file in "$@"
do
    grep ^http $file | xargs -L1 -t curl > /dev/null
    shift
done
