#!/bin/sh

OWNER='root:root'

cd $1
find . -name "$2.*" | awk -v old=$2 -v new=$3 '{x=$0;gsub(old, new);print "cp "x" "$0}' | sh
find . -name "$3.*" | awk -v owner=$OWNER '{print "chown "owner" "$0"; chmod a+r "$0}' | sh
