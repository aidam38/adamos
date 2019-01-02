#!/bin/bash

srclist=$1
echo -e "$srclist" > bulktmp
nvim bulktmp
trglist="$(cat bulktmp)"

srcn=$(echo "$srclist" | wc -l) &>/dev/null
trgn=$(echo "$trglist" | wc -l) &>/dev/null

if [[ $srcn -eq $trgn ]]; then
	for (( n=1; n<=srcn; n++)); do
		mv -vi "$(sed -n ${n}p <<< "$srclist")" "$(sed -n ${n}p <<< "$trglist")"
	done
else
	echo "Invalid input. Number of lines don't match."
fi
rm bulktmp
