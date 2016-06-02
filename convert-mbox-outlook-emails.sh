#!/bin/sh

# Script configurations
FILE_SED=`basename "$0"`.sed
DIR=`dirname "$0"`

# Validate parameters
if [[ "$#" != "1" ]]; then
	echo 
	echo Convert outlook verbose style emails in an mbox file,
	echo given filename the script \"$FILE_SED\" located in 
	echo -e "\t\"$DIR\""
	echo 
	echo Usage: `basename "$0"` filename
	echo 
	exit -1
fi
FILE="$1"
FILE_TMP=$FILE.tmp

# Convert the file
sed -f "$DIR/$FILE_SED" "$FILE" > "$FILE_TMP"
mv "$FILE_TMP" "$FILE"
echo converted $FILE
find . -name "*.tmp" -ls
