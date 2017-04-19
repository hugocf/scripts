#!/usr/bin/env bash

# Created by Hugo Ferreira <hugo@mindclick.info> on 2014-02-09.
# Copyright (c) 2014 Mindclick. All Rights Reserved.
# Licensed under the MIT License: https://opensource.org/licenses/MIT
readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from
readonly STATUS_SUCCESS=0                       # exit status for commands

# Script configuration
readonly CMD_MAKE_POT="php ${HOME}/Work/Sandbox/wordpress/i18n-tools.svn/makepot.php"

# Script functions
function usage () {
    echo "
Usage: $(basename $0) slug folder

    -h          this usage help text
    slug        the base name to use for the plugins and theme
    folder      location of the wordpress installation

Regenerates the .pot file of custom plugins and theme with a common slug.

Example:
    $(basename $0) clientname ./wordpress/"
    exit ${1:-0}
}

function ask_if_empty () {
    local value="$1"
    local default="$2"
    local message="$3"
    local options="$4"  # pass "-s" for passwords
    if [[ -z "$value" ]]; then
        read $options -p "$message [$default] " value
    fi
    value=$(echo ${value:-$default})
    echo "$value"
}

function make_pot () {
    local kind="$1"
    local slug="$2"
    local folder="$3"
    local prepare=:     # noop
    local cleanup=:     # noop
    case "$kind" in
        themes)
            kind_type='wp-theme'
            ;;
        plugins)
            kind_type='wp-plugin'
            ;;
        mu-plugins)
            prepare=mu_plugin_setup
            slug="$slug-mu"
            kind_type='wp-plugin'
            cleanup=mu_plugin_cleanup
            ;;
    esac
    $prepare $slug $folder
    $CMD_MAKE_POT "$kind_type" "$folder/wp-content/$kind/$slug/" "$folder/wp-content/$kind/$slug/$slug.pot"
    $cleanup $slug $folder
}

function mu_plugin_setup () {
    local slug="$1"
    local folder="$2"
    mkdir -p "$folder/wp-content/mu-plugins/$slug"
    ln -nfs "../$slug.php" "$folder/wp-content/mu-plugins/$slug/$slug.php"
}

function mu_plugin_cleanup () {
    local slug="$1"
    local folder="$2"
    mv "$folder/wp-content/mu-plugins/$slug/$slug.pot" "$folder/wp-content/mu-plugins/"
    rm -rf "$folder/wp-content/mu-plugins/$slug"
}

# Parse command line options
while getopts h option; do
    case $option in
        h) usage ;;
        \?) usage 1 ;;
    esac
done
shift $(($OPTIND - 1));     # take out the option flags

# Validate input parameters
slug=$(ask_if_empty "$1" "clientname" "Enter the slug to use:")
folder=$(ask_if_empty "$2" "." "Enter the WordPress folder:")
if [[ ! -a "$folder/wp-config.php" ]]; then
    echo;
    echo "Folder '$folder' doesn't seem to be a WordPress installation";
    exit 1;
fi

# Do the work
make_pot 'themes' $slug $folder
make_pot 'plugins' $slug $folder
make_pot 'mu-plugins' $slug $folder
