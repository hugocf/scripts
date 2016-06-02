#!/bin/sh

echo "\n\tUsage: `basename $0` /path/to/VIDEO_TS/parent/folder\n"

DIR=$1
NAME=$(basename "${DIR}")
hdiutil makehybrid -udf -udf-volume-name "${NAME}" -o "${NAME}" "${DIR}"
