#!/bin/bash
# Created by Hugo Ferreira <hugo@ferreira.cc> on 2010-01-16.
# Copyright (c) 2010 Hugo Ferreira. All Rights Reserved.
# Licensed under the MIT License: https://opensource.org/licenses/MIT

usage() {
  echo "
Usage: `basename $0` [domain1 domain2 ...]

Requests Header information to each one of the websites at the given domains,
and reports those that were not accessible.

Example:
    `basename $0` google.com example.com
"
    exit ${1:-0}
}

list() {
  for item in $*; do
    echo "  $item"
  done
}

failed=""
code=0

# Exit if we don't have any parementers
if [[ $# = 0 ]]; then
  usage 1
fi

# Check each website
for site in $*; do
  curl -I http://$site > /dev/null 2>&1
  retval=$?
  if [[ $retval != 0 ]]; then
    code=1
    failed+="$site "
  fi
done

# Report the result
if [[ $code == 0 ]]; then
    echo "All sites accessible!"
else
    echo "Couldn't reach websites:"
    list $failed
fi
exit $code
