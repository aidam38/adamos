#!/bin/bash

#nohup st -e lf $(fzf | sed 's/ /\\ /g' | sed 's/\(.*\)\//\1:/' | awk -F ":" '{print $1}') &>/dev/null
lf $(dirname $(fzf))
