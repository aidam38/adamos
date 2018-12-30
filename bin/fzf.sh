#!/bin/bash

cd $(fzf | sed 's/ /\\ /g' | sed 's/\(.*\)\//\1:/' | awk -F ":" '{print $1}')
