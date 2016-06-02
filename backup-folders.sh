#!/bin/sh
#
# Backs up the contents of a folder either by making a complete copy
# (recursive) of its contents, or by zipping each top level element
# of that folder independently 
#
# Configure the relevant directories at the beggining of the file.
#
# Note: if using UnxUtils in a Windows environment...
#	1. use forward slashes '/' when defining the directories
#	2. this scipt requires the following files in the path:
#		basename.exe
#		cp.exe
#		date.exe
#		grep.exe
#		ls.exe
#		mkdir.exe
#		sh.exe
#		uname.exe
#		zip.exe
#
# Created by Hugo Ferreira <hugo@ferreira.cc> on 2006-05-25.
#
SOURCE_COPY_DIR="/webMethods/DV/IntegrationServer/replicate/outbound"
SOURCE_ZIP_DIR="/webMethods/DV/IntegrationServer/packages"
TARGET_DIR="/webMethods Backups/HPSAS53"
REDUNDANCY_DIR="\\\\hpsas54/d$/webMethods Backups/HPSAS53 (redundancy)"

# Local script settings
case `uname` in
	Windows*)	LINKS_FLAG= ;;
	*)       	LINKS_FLAG=-y ;;
esac
TIMESTAMP=`date '+%Y-%m-%d @ %Hh%M'`
BACKUP_DIR="$TARGET_DIR/$TIMESTAMP"

# Prepare backup storage
mkdir -p "$BACKUP_DIR"

# Backup: copy all
TARGET_COPY_DIR="$BACKUP_DIR/`basename "$SOURCE_COPY_DIR"`"
mkdir -p "$TARGET_COPY_DIR"
cp -Rfp "$SOURCE_COPY_DIR/." "$TARGET_COPY_DIR"

# Backup: zip each element
TARGET_ZIP_DIR="$BACKUP_DIR/`basename "$SOURCE_ZIP_DIR"`"
mkdir -p "$TARGET_ZIP_DIR"
cd "$SOURCE_ZIP_DIR"
for element in `ls -1 | grep -v "^Wm"`; do 
	zip -qr $LINKS_FLAG "$TARGET_ZIP_DIR/$element" "$element"
done

# Make a redundant copy of this backup to another disk
cp -Rfp "$BACKUP_DIR" "$REDUNDANCY_DIR/$TIMESTAMP"


