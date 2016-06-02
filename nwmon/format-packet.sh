#!/usr/bin/env bash
# 
# Formatting tool to enhance the packet output of the tcpdump utility with
# information regarding the <pid> and <command> originating the network packet.
# 
# It searches for the packet lan <port> number and, based on that, adds the columns:
#   <app> <pid> (...) <cmd>
# 
# where,
#   <app> = name of the UNIX command associated with the process (e.g. ssh)
#   <pid> = the process id
#   (...) = the original tcpdump packet string
#   <cmd> = command and arguments (e.g. ssh example.com)
#
# Useful aliases for your profile, to monitor downloads and uploads:
#   alias nwmon='sudo tcpdump -l -q -ien1 | format-packet.sh'
#   alias nwin='sudo tcpdump -l -q -ien1 dst `hostname -s` | format-packet.sh'
#   alias nwout='sudo tcpdump -l -q -ien1 src `hostname -s` | format-packet.sh'
# 
#
# Created by Hugo Ferreira <hugo@ferreira.cc> on 2010-01-21.
# Copyright (c) 2010 Hugo Ferreira. All Rights Reserved.
# Licensed under the BSD License: http://creativecommons.org/licenses/BSD

function format () {
  line=$*
  port=`echo $line | sed -E 's/.*lan\.([0-9]+).*/\1/g'` # FIXME: the other comp can also be in .lan
  info=(`sudo lsof -Fpc -i:$port | cut -c2-`)   # returns: <pid> <app>
                                                # sudo because it needs to see files from all users
#  app=`ps -o command= -c -p$pid`
#  cmd=`ps -o command= -p$pid`
  echo "${info[1]}[${info[0]}] $line"
}

# Read from whatever: pipe, stdin, redirected file or arguments
if [[ $# == 0 ]]; then
  while read line; do
    format $line
  done
else
    format $*
fi


###
# sudo cp /Users/hugo/Work/Scripts\ \&\ Macros/Unix\ Shell/format-packet.sh /usr/local/bin/
