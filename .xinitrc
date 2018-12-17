#!/bin/bash

compton -CG --no-fading-openclose --no-fading-destroyed-argb --focus-exclude "x = 0 && y = 0 && override_redirect = true" &
feh --bg-scale /home/adam/.wallpapers/bg1.jpg &
xmodmap /home/adam/.Xmodmap &
setxkbmap -layout cz,us -option grp:alt_caps_toggle -option caps:swapescape -option terminate:ctrl_alt_bksp &
numlockx &
pulseaudio --start &
dunst &
redshift &

while true;
do
	if [[ $(pamixer --get-mute) == "true" ]]; then
		xsetroot -name "-1% | $(date "+%a %d. %m. | %T")"
	else
		xsetroot -name "$(pamixer --get-volume)% | $(date "+%a %d. %m. | %T")"
	fi
	sleep 1
done &
exec dwm
