#!/bin/bash
file=$(echo $1 | sed "s/.pdf$//")
pdftotext -enc UTF-8 -eol unix "$file.pdf" "${file}_tmp.txt"
sed "y/ÈèìØøùòï¡¾æ/ČčěŘřůňď'ľ_/" ${file}_tmp.txt > "${file}_tmp_rep.txt"
iconv --from utf8 --to 8859_2 "${file}_tmp_rep.txt" > "${file}_tmp-1250.txt"
iconv --from cp1250 --to utf8 "${file}_tmp-1250.txt" > "${file}.txt"
