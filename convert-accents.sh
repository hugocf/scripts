#!/bin/sh
#
# Convert accentuated chars to their plain text equivalent
#

# Convert the text
normalise_accents() {
echo "$1" | sed -e "
	y/àáâãäåèéêëìíîïòóôõöùúûü/aaaaaaeeeeiiiiooooouuuu/
	y/ÀÁÂÃÄÅÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜ/AAAAAAEEEEIIIIOOOOOUUUU/
	y/çñß¢Ð£Øø§µÝý¥¹²³/cnbcdloosuyyy123/
	y/ÇÑß¢Ð£ØØ§µÝÝ¥¹²³/CNBCDLOOSUYYY123/
"
}

# Validate parameters
if [[ "$#" == "0" ]]; then
    while read data; do
        normalise_accents "$data"
    done
else
    normalise_accents "$*"
fi

