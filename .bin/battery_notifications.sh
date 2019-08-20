#!/usr/bin/bash

# battery=$(sudo tlp-stat -b | grep "Charge total" | awk '{print $5}')
battery="49.0"

if [[ -z $BATTERY ]]; then
	BATTERY=100.00
fi

if [[ -z $THRESHOLD ]]; then
	threshold=50.0
else
	threshold=$THRESHOLD
fi

if [[ $battery < $threshold ]] && [[ $BATTERY > $threshold ]]; then
	threshold=$(echo "$threshold/2" | $(which bc) -l)
	bat=$(printf "%.*f" 0 $battery)
	bar=$(echo "$(seq -s "─" $(($bat/5)))$(seq -s " " $(((100-$bat)/5)))" | sed 's/[0-9]//g')
	dunstify -t 2000 -r 557 "⚡$battery% < $THRESHOLD% | $bar |"
fi

export BATTERY="$battery"
export THRESHOLD="$threshold"
