# Unix Info

*(most recent on top; mainly macOS; mainly `bash`)*

[TOC]

## Check and make sure a script is sourced

```shell
# Exit if this script was not sourced as an import
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    >&2 echo "Error: Must run as an import source"    # stderr
    >&2 echo "Try: source \"${BASH_SOURCE[0]}\""      # stderr
    exit
fi
```



## Run two commands in parallel and wait for their result

```shell
command1 &
command2 &
wait %1 && wait %2
echo $?
```



## Read secret into a variable

```shell
read -s TOKEN               # silent typing
read -s -p "Token?" TOKEN   # … with prompt
```



## Increment a counter / calculate expressions

- [math - Bash: evaluate a mathematical term? - Stack Overflow](https://stackoverflow.com/questions/2552130/bash-evaluate-a-mathematical-term/2552184#2552184)

*… count from 0*

```shell
let count=$count+1   # count = 1, 2, 3, ...
((count=count+1))    # count = 1, 2, 3, ...
value=$((count-1))   # value = 0, 1, 2, ...
```

*… count from N = 10*

```shell
let count=${count:-10}+1
```



## Group and count number of multiple occurrences of the same line

- [Sort and count number of occurrence of lines - Unix & Linux Stack Exchange](https://unix.stackexchange.com/a/170044)

```shell
cat file | sort | uniq -c | sort -r
```



## Remove extension from a filename

```shell
filename=some.example.name.txt
echo ${filename%.*}  # => some.example.name
```



## Default missing variable to a value

```shell
set -u  # treat unset variables as errors
echo ${1:-}   # => empty
echo ${1:-0}  # => 0
echo ${1:-X}  # => X
```



## Use multiline heredoc or var as an input file

```shell
cat <<WORD
lorem
ipsum
WORD
```

```shell
echo "\
lorem
ipsum
"
```



## View zip or jar files

```shell
view some.jar
```

```shell
unzip -c some.jar path/to/file.txt
```



## Transforming and parsing JSON

- [jq Manual (development version)](https://stedolan.github.io/jq/manual/)

*… useful options*

```shell
-c	--compact-output
-r	--raw-output
-S	--sort-keys
```

*… subset of keys*

```shell
json='[{"name":"a", "id":1, "extra":"foo"}, {"name":"b", "id":2, "extra":"bar"}]'
echo $json | jq -c '.[] | { id, name }'   # {"id":1,"name":"a"}
                                          # {"id":2,"name":"b"}
```

*… select array elements*

```shell
json='[{"key":"a"}, {"key":"b"}, {"key":"c"}]'
echo $json | jq -c '.[0]'     # { "key": "a" }
echo $json | jq -c 'first'    # { "key": "a" }
echo $json | jq -c 'nth(1)'   # { "key": "b" }
echo $json | jq -c 'last'     # { "key": "c" }
```

*… “transpose”*

```shell
json='[{"key":"a", "value":1}, {"key":"b", "value":2}]'
echo $json| jq -c 'from_entries'  # { "a": 1, "b": 2 }
```

*… use some values as keys*

```shell
json='[{"name":"a", "id":1, "extra":"foo"}, {"name":"b", "id":2, "extra":"bar"}]'
echo $json | jq -c '.[] | [{ "key": .name, "value": .id }] | from_entries'
# { "a": 1, "b": 2 }
```

*… default `null` to empty string*

```shell
value=$(jq -r '.path.to.attr')
echo ">$value<"		# >null<

value=$(jq -r '.path.to.attr // empty')
echo ">$value<"		# ><
```



## Special tips about `sed`

- [Sed Command in Unix and Linux Examples](http://www.folkstalk.com/2012/01/sed-command-in-unix-examples.html)

*… substitution separators are configurable to avoid escaping ‘/’*

```shell
sed 's_http://_www._' file.txt  # http://example.com => www.example.com
sed 's|http://|www.|' file.txt  # http://example.com => www.example.com
```

*… refer to the matched search string*

```shell
sed 's/unix/& \& linux/'        # open source unix os => open source unix & linux os
```



## Bouncing `systemd` services

```shell
cd /etc/systemd/system			  # => servname.service
sudo systemctl stop servname	# stop the service
sudo systemctl daemon-reload	# reload changes from disk
sudo systemctl start servname	# start the service
systemctl status ser*			    # what’s going on?
```



## Using color escape sequences in echo command

```shell
echo $'\e[1;34m'"text"$'\e[0m'
```

*… using a variable instead of the escape sequence **does no work!***

```shell
FOO='\e[1;34m'
echo $FOO"text"$'\e[0m'   # \e[1;34mtext
```



## Bash noop command (colon)

```shell
if [[ $a == $b ]]; then
    :  # TODO
fi
```



## List wildcard directories without showing its contents

```shell
ls -1d pattern*
```



## Continue a command in the next line

- [Bash Continue Command / Script On The Next Line](http://www.cyberciti.biz/faq/howto-ask-bash-that-line-command-script-continues-next-line/)

```shell
commannd1 -arg1 -arg2 \
          -arg3 -arg4 \
          -arg5 -arg6
```



## Read lines from a file, one at a time

- [linux - Looping through the content of a file in Bash? - Stack Overflow](http://stackoverflow.com/questions/1521462/looping-through-the-content-of-a-file-in-bash/1521498#1521498)
- [bash - Read a file line by line assigning the value to a variable - Stack Overflow](https://stackoverflow.com/questions/10929453/read-a-file-line-by-line-assigning-the-value-to-a-variable/10929511#10929511)

*… excludes the last line if it doesn’t end with a newline* ⚠️

```shell
while read -r line; do
    echo $line
done < $filename
```

*… does not stop to enter data manually if the loop is interactive (e.g. reads from stdin)* ⚠️

```shell
while IFS='' read -r line || [[ -n "$line" ]]; do
    echo $line
done < $filename
```



## Where a script is located and from where was it called

```shell
readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from
```



## Check for environment variables

*… make sure it **is defined***

```shell
[[ $ISDEFINED ]]; echo $?    # => 0 (success)
[[ $UNDEFINED ]]; echo $?    # => 1 (error)
```

```shell
[[ $ISDEFINED ]] && echo "yes" || echo "not"    # => yes
[[ $UNDEFINED ]] && echo "yes" || echo "not"    # => not
```

```shell
if [[ $ISDEFINED ]]; then echo "yes"; else echo "not"; fi    # => yes
if [[ $UNDEFINED ]]; then echo "yes"; else echo "not"; fi    # => not
```

*… make sure it **is not defined***

```shell
[[ -z $ISDEFINED ]]; echo $?    # => 1 (error)
[[ -z $UNDEFINED ]]; echo $?    # => 0 (success)
```

```shell
[[ -z $ISDEFINED ]] && echo "not" || echo "yes"    # => yes
[[ -z $UNDEFINED ]] && echo "not" || echo "yes"    # => not
```

```shell
if [[ -z $ISDEFINED ]]; then echo "not"; else echo "yes"; fi    # => yes
if [[ -z $UNDEFINED ]]; then echo "not"; else echo "yes"; fi    # => not
```



## Recursively grep files with specific patterns

```shell
grep -ri "pattern" . --include "*.txt" --include "*.md" --exclude "README.*"
grep "pattern" filemask* --exclude-dir "test" --exclude-dir "target"
```



## Remove an environment variable

```shell
unset ENV_VAR
```



## Pass boolean values as parameters to bash functions

- [bash - How to declare and use boolean variables in shell script? - Stack Overflow](http://stackoverflow.com/a/21210966/1380781)

```shell
bool=true
if [ "$bool" = true ]; then echo "yes"; fi      # yes
if [[ "$bool" == true ]]; then echo "yes"; fi   # yes
```



## Return values from bash functions

- [Returning booleans from Bash functions | // nothing works](http://nothingworks.donaitken.com/2012/04/returning-booleans-from-bash-functions)
- [Linux tip: Bash test and comparison functions](http://www.ibm.com/developerworks/library/l-bash-test/)

```shell
readonly SUCCESS=0    # exit status of bash commands
```

*… capture the return value of a function*

```shell
get_value () {
  echo "$variable"
}
value=$(get_value)
```

*… check if the last command executed with success*

```shell
is_equal () {
  [[ "$1" == "$2" ]]
}

is_equal && echo ok || echo not ok          # ok
is_equal a b && echo ok || echo not ok      # not ok
```

```shell
is_valid () {
  grep -q "$looking_for" "$file"
}

is_valid && echo found || echo not found                          # not found; stderr msg
if [[ is_valid == 0 ]]; then echo found; else echo not found; fi  # not found; no stderr msg
```



## Dereference bash variable param substitution/expansion

```shell
TEST=foobar
var="TEST"
echo "${!var}"    # => foobar
```



## Check if a directory is empty

```shell
[[ $(find /some/dir/ -maxdepth 0 -type d -empty 2> /dev/null) ]] \
	&& echo "Empty" \
	|| echo "Not empty or missing"

[[ "$(ls -A /some/dir/ 2> /dev/null)" ]] \
	&& echo "Not empty" \
	|| echo "Empty or missing"
```



## Look for empty directories

```shell
find . -type d -empty
```



## Exclude hidden dot files when searching

- [Find command: Exclude or Ignore Files (e.g. Ignore All Hidden .dot Files )](http://www.cyberciti.biz/faq/find-command-exclude-ignore-files/)

```shell
find . -type file ! -name ".*"
find . -type file ! \( -name ".*" -or -path "*/.sync/*" \)
```

```shell
find . -type file -not -name ".*"
find . -type file -not -name ".*" -not -path "*/.sync/*"
find . -type file -not \( -name ".*" -or -path "*/.sync/*" \)
```



## Show function definition

```shell
declare -f functionname
```



## Check open files

```shell
lsof | grep file
```



## Check open ports

- [terminal - How can I list my open network ports with netstat? - Ask Different](http://apple.stackexchange.com/a/117648/66527)

```shell
sudo lsof -i -P | grep :8080
```



## Monitor network traffic

```shell
sudo tcpdump -ien1 -q
sudo lsof -i:8080
```



## `vi` survival commands

*… exit and save*

```shell
⇧-Z-Z
:wq
:x
```

*… exit without saving*

```shell
⇧-Z-Q
:q!
```



## `vi` default settings: `~/.vimrc`

```shell
backup files:           :set backupdir=~/tmp
use lighter colors:     :set background=dark
dos/unix file format:   :set ff=unix|dos
```



## Remove trailing newlines

```shell
echo -n "`cat file`" > file
```



## Convert date to/form epoch

```shell
date -r 1234567890
date -r 1294897379 +"%Y-%m-%d %H:%M:%S"                  # 2011-01-13 05:42:59
date -jf "%Y-%m-%d %H:%M:%S" "2011-01-13 05:42:59" +%s   # 1294897379
```



## Difference between 2 dates

```ruby
ruby -r 'date' -le 'puts "#{Date.today - Date.new(2007,11,30)} days"'
```

```python
python -c "import datetime; print datetime.date.today() - datetime.date(2009,9,1)"
```



## Subtract days to a date

```shell
expr -1 \* 24 \* 60 \* 60 + `date +%s` | xargs date -r
```

```ruby
ruby -r 'date' -le 'puts "#{Date.today - 1}"'
ruby -r 'date' -le 'puts "#{Date.today << 1}"'
```

```python
python -c "import datetime; print datetime.date.today() - datetime.timedelta(days=1)"
```



## Current week number	

```shell
man strftime	# list of formats
```

```shell
date +%V
```

```ruby
ruby -e 'puts (Time.now).strftime("%V")'
```

```python
python -c "import time; print time.strftime('%W')"
python -c "import datetime; print datetime.date(2009,9,1).strftime('%W')"
```



## Files paches

```shell
diff -u [raN] old new > patch.diff
patch [-pnum] < patch.diff
```



## Dos => Unix => Dos

```shell
# ^M = ctrl-V ctrl-M
```

*… unix2dos*

```shell
 sed -e 's/$/^M/' unix.file > dos.file
```

*… dos2unix*

```shell
sed -e 's/^M//' dos.file > unix.file
tr -d \\r < dos.file > unix.newfile
```



## Test a POP3 server

* [RFC 1939 - Post Office Protocol - Version 3](https://tools.ietf.org/html/rfc1939)

```shell
$ telnet myserver 110
user myusername
pass mypassword
stat | list | retr <msgnbr> | dele <msgnbr>
quit
```



## Manage postfix mail queues

```shell
sudo tail -f /var/log/postfix.log   # check what postfix is doing
mailq                               # see what is in the queue
postsuper -d id                     # delete a mail from the queue (id from mailq)
postsuper -d ALL                    # delete all mail from the queue
```



## Unix distribution name/version

*… depending on the distro*

```shell
dmesg | head -1
cat /proc/version
cat /etc/issue      # human-readable
uname -a            # full summary
```



## Shell redirections

- [Illustrated Redirection Tutorial [Bash Hackers Wiki]](https://wiki.bash-hackers.org/howto/redirection_tutorial)
- [bash - echo that outputs to stderr - Stack Overflow](https://stackoverflow.com/questions/2990414/echo-that-outputs-to-stderr/23550347#23550347)

*… `stdout`*

```shell
cmd > /dev/null           # … to file
cmd	>&2                   # … to stderr
```

*… `stderr`*

```shell
cmd 2> /dev/null          # … to file
cmd 2>&1                  # … to stdout
```

*… `stdout` and `stderr`*

```shell
cmd &> /dev/null          # … to file
cmd > /dev/null 2>&1      # … to file
cmd 2>&1 | cmd            # … to pipe
cmd 2>&1 | tee file.txt   # … to console and file
```

*… `stdout` and `stderr` (bash 4)*

```shell
cmd &>> /dev/null         # … to file
cmd |& cmd                # … to pipe
```



## Common lines between two files

- [text processing - Common lines between two files - Unix & Linux Stack Exchange](https://unix.stackexchange.com/a/398143)

```shell
comm -12 file1 file2
grep -Fxf file1 file2
```

```perl
perl -ne 'print if ($seen{$_} .= @ARGV) =~ /10$/' file1 file2
```



## Compile `.po` message files into `.mo` data files

```shell
msgfmt -o filename.mo filename.po
```



## Create a fake blank file of any size

*… e.g. 10KiB*

```shell
dd if=/dev/zero of=myfile bs=1024 count=10
```



## Split very long xml lines in tags

*… insert a newlines!*

```shell
# it's one single command line!
sed -e 's/\>\</\>\
\</g' x.xml > x-fixed.xml
```



## Port forwarding through remote host

```shell
ssh server -L 4321:servername:80
```



## Encode string using openssl

*… from string*

```shell
echo -n "qwerty" | openssl base64   # cXdlcnR5
echo -n "qwerty" | openssl md5      # d8578edf8458ce06fbc5bb76a58c5ca4
echo -n "qwerty" | openssl sha1     # b1b3773a05c0ed0176787a4f1574ff0075f7521e
```

*… from input*

```shell
openssl base64|md5|sha1
^D
```



---

