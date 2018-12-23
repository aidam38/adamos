#!/usr/bin/bash

echo "Number of words: " $(pdftotext $1 - | wc -w) ", number of characters: " $(pdftotext $1 - | wc -m)
