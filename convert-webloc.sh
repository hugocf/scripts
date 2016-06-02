#!/bin/sh

# http://www.macosxhints.com/article.php?story=20040728185233128
if [ $# -lt 1 ]; then
echo << EOF "
Usage: `basename $0` "file1.webloc" "file2.webloc" ...

Converts Mac style web location files into
PC style internet shortcut files.

Can convert multiple files listed on command line.
Filenames with spaces must be quoted.

ex: convert all .webloc files in given directory to .url files
$ `basename $0` *
"
EOF
fi

for i in "$@"
do
    url_name="`echo "$i" | sed 's/.webloc/.url/g'`"
    url="$(strings "$i" | grep -A1 URL | tail -1 | sed -E 's/.*http/http/')"

    cat << EOF >$url_name
[InternetShortcut]
URL=$url
EOF

    echo "Conversion completed and saved as:"
    echo "       $url_name"
    echo ""
    shift
done
