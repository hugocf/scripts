#!/usr/bin/env bash

# Created by Hugo Ferreira <hugo@mindclick.info> on 2014-03-19.
# Copyright (c) 2014 Mindclick. All Rights Reserved.
# Licensed under the MIT License: https://opensource.org/licenses/MIT
readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from
readonly STATUS_SUCCESS=0                       # exit status for commands

# Script functions
function usage () {
    echo "
Usage: $(basename $0) [options] folder package archtype

    -h          this usage help text
    folder      root level directory to create
    package     package to use for the classes
    archtype    what kind of Maven archtype to generate
                http://docs.codehaus.org/display/MAVENUSER/Archetypes+List

Generates a new Maven project according to the given parameters.

Example:
    $(basename $0) example com.example"
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

# Parse command line options
while getopts abn:h option; do
    case $option in
        h) usage ;;
        \?) usage 1 ;;
    esac
done
shift $(($OPTIND - 1));     # take out the option flags

# Validate input parameters
folder=$(ask_if_empty "$1" "example" "Enter the directory to create:")
package=$(ask_if_empty "$2" "com.example" "Enter the Java package to use:")
archtype=$(ask_if_empty "$3" "maven-archetype-quickstart" "Enter the archtype to generate:")

# Do the work
mvn archetype:generate -Dversion=0.0 -DgroupId="$package" -DartifactId="$folder" -DarchetypeArtifactId="$archtype" -DinteractiveMode=false
mate "$folder/pom.xml"
