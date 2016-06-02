#!/bin/sh
#
# Prevent accidentally killing all processes.
# Ask confirmation message if any of the parameters is -1, 0 or 1.
# It is completly transparent otherwise.
#
# Goes together with adding an alias to file /etc/profile.d/alias.sh
#       alias kill="/usr/local/bin/kill.sh"
#
# Author: Hugo Ferreira
#
DANGER=0
CMD=kill

if [[ "$#" == "0" ]]; then
        echo "(using wrapper: $0)"
fi

for i in $*; do
        case $i in
                '-1') DANGER=1; MSG='-1 (all processes with pid larger than 1)'; break;;
                 '0') DANGER=1; MSG='0 (all processes in the current process group)'; break;;
                 '1') DANGER=1; MSG='1 (main process "init" - will cause shutdown)'; break;;
        esac
done;

if [[ $DANGER == 1 ]]; then
        echo
        echo `whoami`": WARNING! Killing "$MSG
        echo `whoami`": Are you sure?"
        select result in yes no; do break; done;

        if [[ $result == 'yes' ]]; then
                echo "(killing...)"
                echo
        else
                echo "(aborting...)"
                echo
                exit -1
        fi
fi

# Execute the command
$CMD $*
