#!/usr/bin/bash

cat /home/adam/scripts/script_snippets | dmenu | awk -F'\t' '{print $3}' | xsel --input --clipboard
