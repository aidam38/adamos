#!/usr/bin/env bash

if [ -r "$HOME/.dbus/Xdbus" ]; then
  . "$HOME/.dbus/Xdbus"
fi

charging=$(sudo tlp-stat -b | grep "Charging")
notify-send $charging
if [[ -n $charging ]]; then

	loc="/home/adam/scripts/notifications"

	if [[ ! -f $loc/BATTERY ]]; then
		echo "100.00" > $loc/BATTERY
	fi

	BATTERY=$(cat $loc/BATTERY)
	battery=$(sudo tlp-stat -b | grep "Charge total" | awk '{print $5}')

	threshold=100.0
	while [[ $(echo "$threshold>$BATTERY" | bc -l) == "1" ]]; do
		threshold=$(echo "$threshold/2" | bc -l)
	done

	if [[ $battery < $threshold ]] && [[ $BATTERY > $threshold ]]; then
		paplay "$loc/battery.wav"

		bat=$(printf "%.*f" 0 $battery)
		bar=$(echo "$(seq -s "─" $(($bat/5)))$(seq -s " " $(((100-$bat)/5)))" | sed 's/[0-9]//g')
		dunstify -t 6000 -r 557 "⚡ < $(printf "%3.2f" $threshold)% | $bar |"
		# $(printf "%3.2f" $battery)%

		threshold=$(echo "$threshold/2" | $(which bc) -l)
	fi

	echo "$battery" > $loc/BATTERY
fi
