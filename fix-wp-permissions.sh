#!/bin/sh

usage() {
    echo "
Usage: $(basename $0) dir

    dir     Directory where the archive files are located.

Normalise all the file & directory permissions before importing to the repo.
Example:
    $(basename $0) ~/Desktop/site-archive-sitename-20131230"
    exit ${1:-0}
}

archive_dir=$1
[ -z "$archive_dir" ] && usage 1

find "$archive_dir" -type f -exec chmod a+w,a-x {} \;
find "$archive_dir" -type d -exec chmod a+w,a+x {} \;
