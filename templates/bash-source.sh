#!/usr/bin/env bash
# Created by Hugo Ferreira <hugo@ferreira.cc> on isoD
# Licensed under the MIT License: https://opensource.org/licenses/MIT

set -u  # treat unset variables as errors

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "Error: Must run as an import source"
    echo "Try: source ${BASH_SOURCE[0]}"
    exit
fi

export VAR="value"
