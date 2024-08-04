# Created by Hugo Ferreira <hugo@mindclick.info> on 2010-11-03.
# Copyright (c) 2010 Mindclick. All Rights Reserved.
# Licensed under the MIT License: https://opensource.org/licenses/MIT
 
#
# Fetchs all the remoted branches from a list of local repos.
#
 
# Replace whatever extension of script name with .cfg
CONFIG="${0%.*}.cfg"
 
fetchall() {
    tgt=$1
    echo
    echo $tgt
    cd "$tgt" && git fetch --all --verbose
}
 
if [ ! -f "$CONFIG" ]
then
    echo "ERROR: Couldn't find config file with repo paths -- $CONFIG"
    echo
    echo "Generating a new file with placeholder repo paths:"
    echo "      1. Edit the file"
    echo "      2. Add actual paths to repos"
    echo "/Users/username/path/to/local/repo1.git/
/Users/username/path/to/local/repo2.git/" > $CONFIG
    echo
    ls -l $CONFIG
    exit 1
fi
 
while read path
do
    fetchall "$path"
done < "$CONFIG"
 
echo && read -n1 -p "(press any key to continue)"
