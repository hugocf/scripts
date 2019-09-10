#!/usr/bin/env bash
# Created by Hugo Ferreira <hugo@ferreira.cc> on isoD
# Licensed under the MIT License: https://opensource.org/licenses/MIT

set -u  # treat unset variables as errors

# Exit if this script was not sourced as an import
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    >&2 echo "Error: Must run as an import source"    # stderr
    >&2 echo "Try: source \"${BASH_SOURCE[0]}\""      # stderr
    exit
fi

export VAR="value"
