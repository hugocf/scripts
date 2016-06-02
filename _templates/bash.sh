#!/usr/bin/env bash

# Created by Hugo Ferreira <hugo@ferreira.cc> on isoD
# Licensed under the BSD License: http://creativecommons.org/licenses/BSD
readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from
readonly SUCCESS=0                              # exit status of bash commands

# Script configuration
readonly CONSTANT="value"

# Script functions
function usage {
    echo "
Description of the script.

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

function ask_if_empty {
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

# Exit and show help if the command line is empty
[[ ! "$*" ]] && usage 1

# Initialise options
n_value="value if option is missing"

# Parse command line options
while getopts abn:h option; do
    case $option in
        a|b) is_flag=1 ;;
        n) n_value=$OPTARG ;;
        h) usage ;;
        \?) usage 1 ;;
    esac
done
shift $(($OPTIND - 1));     # take out the option flags

# Validate input parameters
parameter=$(ask_if_empty "$1" "default value" "Enter the parameter value:")
echo $parameter

# Do the work
:
read -p "Press any key to continue..." -n1 -s
