#!/usr/bin/env bash
readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from

ln -nfs "$2" "$CALLDIR"/"$1"
ln -nfs "$BASEDIR"/config.ru "$1/"

cat << 'END'
Add the following local settings:

>> 'wp-config.php'  # dynamically override the WordPress url definitions

# http://codex.wordpress.org/Editing_wp-config.php#Advanced_Options
define('WP_SITEURL', 'http://' . $_SERVER['SERVER_NAME']);
define('WP_HOME',    'http://' . $_SERVER['SERVER_NAME']);

>> '.gitignore'     # exclude local development configurations

# pow configuration
config.ru

# wordpress debugging files
log.txt
debug.log
END

mate "$1/wp-config.php"
mate "$1/.gitignore"
