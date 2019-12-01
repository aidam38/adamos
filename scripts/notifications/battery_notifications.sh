#!/usr/bin/env bash

if [ -r "$HOME/.dbus/Xdbus" ]; then
  . "$HOME/.dbus/Xdbus"
fi

function show_battery_notification() {
	paplay "$loc/battery.wav"

	bat=$(printf "%.*f" 0 $battery)
	bar=$(echo "$(seq -s "─" $(($bat/5)))$(seq -s " " $(((100-$bat)/5)))" | sed 's/[0-9]//g')
	dunstify -t 6000 -r 557 "⚡ < $(printf "%3.2f" $threshold)% | $bar |"
}

charging=$(sudo tlp-stat -b | grep "Charging")

if [[ -z "$charging" ]]; then

	loc="/home/adam/scripts/notifications"

	if [[ ! -f $loc/BATTERY ]]; then
		echo "100.00" > $loc/BATTERY
	fi

	BATTERY=$(cat $loc/BATTERY)
	battery=$(sudo tlp-stat -b | grep "Charge total" | awk '{print $5}')

	if [[ $battery > 1.0 ]]; then
		threshold=100.0
		while [[ $(echo "$threshold>$BATTERY" | bc -l) == "1" ]]; do
			threshold=$(echo "$threshold/2" | bc -l)
		done

		# dunstify "$battery | $BATTERY | $threshold"

		if [[ $battery < $threshold ]] && [[ $BATTERY > $threshold ]]; then
			show_battery_notification
			threshold=$(echo "$threshold/2" | $(which bc) -l)
		fi
	else
		if [[ $battery < $BATTERY ]]; then
			threshold="$battery"
			show_battery_notification
		fi
	fi
	echo "$battery" > $loc/BATTERY
else
	if [[ $battery == "100.0" ]]; then
		dunstify "⚡Fully charged"
	fi
fi

