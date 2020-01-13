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
    local options="${4:-}"  # pass "-s" for passwords
    if [[ -z "$value" ]]; then
        read $options -p "$message [$default] " value
    fi
    echo "${value:-$default}"
}

check_file_exists () {
    local what=${1:-}
    if [[ ! -f "$what" ]]; then
        >&2 echo "Error: Could not find '$what'"    # stderr
        exit 1
     fi
}

check_tool_exists () {
    local what=${1:-}
    local how=${2:-brew install $what}
    if ! command -v $what > /dev/null; then
        >&2 echo "Error: '$what' command not found"     # stderr
        >&2 echo "Try: $how"                            # stderr
        exit 1
    fi
}

check_var_exists () {
    local what=${1:-}
    if [[ -z "${!what:-}" ]]; then
        >&2 echo "Error: Did not find value for '$what'"    # stderr
        >&2 echo "Try: export $what=something"              # stderr
        exit 1
     fi
}

# Function calling with positional parameters:
#
#   $ example_positional some "foo bar"
#   1st=some 2nd=foo bar 3rd=
#
example_positional () {
    local -r readonly=$1
    local writable=$2
    local optional="${3:-}"
    echo "1st=$readonly 2nd=$writable 3rd=$optional"
}

# Function calling with named parameters:
#
#   $ example_named name=some param="foo bar"
#   1st=some 2nd=foo bar 3rd=default
#
example_named () {
    local name param another
    local "$@"
    local another=${another:-default}
    echo "1st=$name 2nd=$param 3rd=$another"
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
parameter=$(ask_if_empty "${1:-}" "default value" "Enter the parameter value:" "")
echo $parameter

# Validate
check_file_exists $0
check_tool_exists ls
check_var_exists HOME

# Do the work
:   # noop
read -p "Press any key to continue..." -n1 -s
