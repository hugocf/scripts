#!/usr/bin/env bash
# Created by Hugo Ferreira <hugo@ferreira.cc> on isoD
# Licensed under the MIT License: https://opensource.org/licenses/MIT

set -u  # treat unset variables as errors

readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from
readonly SUCCESS=0                              # exit status of bash commands

# Script configuration
readonly CONSTANT="value"

# Script functions
usage () {
    echo "Description of the script.

Usage:
    $(basename $0) [options] param

    -a, -b      explanation of option a (alias b)
    -n value    explanation of option n with value
    -h          this usage help text
    param       description of the parameter

Example:
    $(basename $0) -a -n 1 something"
    exit ${1:-0}
}

ask_if_empty () {
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

check_something () {
    [[ -z "" ]] && (echo "Error: Something is missing"; exit 1)
}

# Function calling with named parameters:
# $ example name=someone param="foo bar"
# > someone received foo bar ()
example () {
    local name param another
    local "$@"
    echo "$name received $param ($another)"
}

# Exit with usage if no params received
[[ ! "$*" ]] && usage 1

# Go home...
cd "$BASEDIR"

# Parse options
n_value="default value if option is missing"
while getopts abn:h option; do
    case $option in
        a|b) is_flag=1 ;;
        n) n_value=$OPTARG ;;
        h) usage ;;
        \?) usage 1 ;;
    esac
done
shift $(($OPTIND - 1));     # take out the option flags

# Set inputs
parameter=$(ask_if_empty "$1" "default value" "Enter the parameter value:" "")
echo $parameter

# Validate
check_something

# Do the work
:   # noop
read -p "Press any key to continue..." -n1 -s
