#!/usr/bin/env bash

# Create a new Rails project and stick it in a newly-created subversion repository.
# I seem to do this often enough that automating it would be nice!
#
# Created by Hugo Ferreira <hugo@ferreira.cc> on 2009-04-26.
# Copyright (c) 2009 Hugo Ferreira. All Rights Reserved. 
# Licensed under the BSD License: http://creativecommons.org/licenses/BSD

# Die on errors!
set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <project> [path]"
    exit 1
fi

project=$1

if [ ! -z "$2" ]; then
    co_path=$2
else
    co_path=${HOME}/src/mine/svn
fi

svnroot="http://svn.rubaidh.com/${project}"

cd ${co_path}
svn mkdir ${svnroot}/{trunk,branches,tags} -m 'create repository layout'
svn co ${svnroot}/trunk ${project}
cd ${project}
rails .
cap --apply-to .
mkdir db/migrate
svn add *

# Remove and ignore logs and temporary files.
svn revert log/*.log
svn propset svn:ignore ".*" log/

for i in log tmp/*; do
    svn propset svn:ignore '*' $i
done


# Fix up any shebang lines that aren't correct.
find . -type f ! -path '*/.svn*' \
    | xargs sed -i '' 's|^#!/.*ruby$|#!/usr/bin/env ruby|g'

# Create the databases on my development machine
mysqladmin create ${project}_development
mysqladmin create ${project}_test

# Set the .htaccess to use the fastcgi version instead
sed -i '' -e 's/^\(RewriteRule.*dispatch\.\)/\1f/' public/.htaccess

# Ignore generated files
svn propset svn:ignore 'api
app
plugins' doc
svn propset svn:ignore 'lighttpd.conf
database.yml' config
svn propset svn:ignore 'schema.rb
development_structure.sql' db

# Pull in and configure the exception_notification plugin
script/plugin install -x exception_notification
cat >> config/environment.rb <<EOF

# Setup the exception notifier.
ExceptionNotifier.exception_recipients = %w(mathie@rubaidh.com)
ExceptionNotifier.sender_address = %("Ruby on Rails" <webmaster@rubaidh.com>)
ExceptionNotifier.email_prefix = "[RoR] "
EOF
svn commit -m 'Skeleton rails imported.'