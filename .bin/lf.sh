#!/bin/bash
function lf-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    lf -last-dir-path="$tempfile" "$*"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

lf-cd "$*" && $SHELL
