#!/bin/sh
#
# Simulate a MySQL database rename by exporting and reimporting into a new one.
#
# Created by Hugo Ferreira <hugo@ferreira.cc> on 2009-11-15.
# Copyright (c) 2009 Hugo Ferreira. All Rights Reserved. 
# Licensed under the BSD License: http://creativecommons.org/licenses/BSD

set -e # exit on error

# Parse parameters
if [ $# -lt 2 ]; then
    echo "usage: `basename $0` old new [user]"
    exit 1
fi

old="$1"
new="$2"
tmp="/tmp/mysql-$1-2-$2.tmp.sql"

if [ ! -z "$3" ]; then
    user="-u $3"
else
    user=''
fi

# Do the work...
mysqldump $user -p -v $old > $tmp
mysqladmin $user create $new
mysql $user $new < $tmp
mysqladmin $user drop $old
rm -f $tmp
