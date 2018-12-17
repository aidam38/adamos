#!/bin/sh

case "$1" in
    *.tar*) tar tf "$1";;
    *.zip) unzip -l "$1";;
    *.rar) unrar l "$1";;
    *.7z) 7z l "$1";;
    *.pdf) pdftotext "$1" -;;
    *.jpg) img2txt "$1";;
    *.png) img2txt "$1";;
    *) highlight --force -O ansi "$1" || cat "$1";;
esac
