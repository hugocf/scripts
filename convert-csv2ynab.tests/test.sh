#!/bin/sh
readonly BASEDIR=$(cd "$(dirname "$0")" && pwd) # where the script is located
readonly CALLDIR=$(pwd)                         # where it was called from

# Colors
readonly BOLD="\033[1m"
readonly INVERT="\033[7m"
readonly NORMAL="\033[0m"

# Script functions
function test_case ()   { echo "$BOLD$INVERT\n => $1: $NORMAL"; }
function validation ()  { echo "\n${BOLD}Validation:$NORMAL"; }
function highlight ()   {
    awk -v good="$1" -v bad="$2" -v normal="$NORMAL" '{
        sub(good, "\033[1;34m" "&" normal)
        sub(bad,  "\033[1;31m" "&" normal)
        print
    }'
}
function highlight_diff () {
    highlight "identical" "differ"
}
alias compare="diff -s -q -w"

# Do the work
test=../convert-csv2ynab.sh
cd $BASEDIR


test_case "Show message when source does not exist"
echo; $test fixtures/_files/bogusfile | highlight "does not exist"


test_case "Don't convert if the format is wrong"
echo; $test fixtures/_files/dummyfile.csv | highlight "File is not"
echo; $test fixtures/_files/dummyfile.txt | highlight "File is not"
echo; $test fixtures/_files/emptyfile     | highlight "File is not"
echo; $test fixtures/dummydir | highlight "File is not"
echo; $test fixtures/emptydir | highlight "No files"


test_case "Parse a single valid file"
###
echo; $test fixtures/_files/bcp.csv | highlight "File parsed"
validation
latest=$(ls -1d fixtures/_files/YNAB-2* | tail -1)
compare fixtures/_files/YNAB-result/bcp.csv "$latest"/bcp.csv | highlight_diff
###
echo; $test fixtures/_files/bcpcredit.csv | highlight "File parsed"
validation
latest=$(ls -1d fixtures/_files/YNAB-2* | tail -1)
compare fixtures/_files/YNAB-result/bcpcredit.csv "$latest"/bcpcredit.csv | highlight_diff
###
echo; $test fixtures/_files/cgp.csv | highlight "File parsed"
validation
latest=$(ls -1d fixtures/_files/YNAB-2* | tail -1)
compare fixtures/_files/YNAB-result/cgp.csv "$latest"/cgp.csv | highlight_diff


test_case "Parse only valid files in a directory"
echo; $test fixtures/convertdir | highlight "File parsed"
validation
latest=$(ls -1d fixtures/convertdir/YNAB-2* | tail -1)
compare fixtures/_files/YNAB-result/bcp.csv "$latest"/bcp.csv | highlight_diff
compare fixtures/_files/YNAB-result/bcpcredit.csv "$latest"/bcpcredit.csv | highlight_diff
compare fixtures/_files/YNAB-result/cgp.csv "$latest"/cgp.csv | highlight_diff


test_case "Must be able to handle filenames with spaces"
echo; $test "fixtures/_files/spaces file.csv"   | highlight "File is not"
echo; $test "fixtures/spaces dir"               | highlight "File parsed"
validation
latest=$(ls -1d fixtures/spaces\ dir/YNAB-2* | tail -1)
compare fixtures/_files/YNAB-result/bcp.csv "$latest/spaces bcp.csv" | highlight_diff
compare fixtures/_files/YNAB-result/bcpcredit.csv "$latest/spaces bcpcredit.csv" | highlight_diff
compare fixtures/_files/YNAB-result/cgp.csv "$latest/spaces cgp.csv" | highlight_diff

