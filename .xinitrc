#!/usr/bin/bash

compton -CG --no-fading-openclose --no-fading-destroyed-argb --focus-exclude "x = 0 && y = 0 && override_redirect = true" &
sxhkd &
feh --bg-scale /home/adam/.wallpapers/bg.* &
setxkbmap -layout cz,us -option grp:alt_caps_toggle -option caps:swapescape -option terminate:ctrl_alt_bksp -option altwin:swap_lalt_lwin &
numlockx &
dunst &
redshift -l 49.1781233:16.5544039 &
clipmenud &
# xmodmap /home/adam/.Xmodmap &
# sudo logkeys --start --keymap /home/adam/scripts/keylogger/cz.keymap -o /home/adam/scripts/keylogger/keys.log &

while true; do
	updatebar;
	sleep 1
done &

exec dwm
