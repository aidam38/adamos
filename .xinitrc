!/usr/bin/bash

compton -CG --no-fading-openclose --no-fading-destroyed-argb --focus-exclude "x = 0 && y = 0 && override_redirect = true" &
feh --bg-scale /home/adam/.wallpapers/bg.png &
xmodmap /home/adam/.Xmodmap &
setxkbmap -layout cz,us -option grp:alt_caps_toggle -option caps:swapescape -option terminate:ctrl_alt_bksp &
numlockx &
dunst &
redshift -l 49.1781233:16.5544039 &
clipmenud &
sudo logkeys --start --keymap /home/adam/scripts/keylogger/cz.keymap -o /home/adam/scripts/keylogger/keys.log &

vol=""
while true; do
	if [ "$(pamixer --get-mute)" = "true" ]; then
		vol="M"
	else 
		vol="$(pamixer --get-volume)%"
	fi
	xsetroot -name " $vol | $(date "+%a %d. %m. | %T")"
	sleep 1
done &
exec dwm
