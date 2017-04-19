#!/usr/bin/env bash
# Created by Hugo Ferreira <hugo@mindclick.info> on 2010-11-02.
# Copyright (c) 2010 Mindclick. All Rights Reserved.
# Licensed under the MIT License: https://opensource.org/licenses/MIT

#
# Checks several reference settings on a new *nix system.
#

check () {
  echo
  echo "> CHECKING: $*"
  $*
}

check pwd
check whoami
check cd ~
check pwd

check which tar
check which find
check which curl
check which wget
check which mysqldump

check which python && python --version
check which ruby && ruby --version
check which rails && rails --version
check which git && git --version
check which hg && hg --version
check which svn && svn --version
check which cvs && cvs --version

check "dmesg | head -1"
check cat /proc/version
check cat /etc/issue  # human-readable
check uname -a        # succinct summary

check set
