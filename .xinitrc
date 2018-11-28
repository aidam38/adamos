#!/bin/sh

compton -CG --no-fading-openclose --no-fading-destroyed-argb --focus-exclude "x = 0 && y = 0 && override_redirect = true" &
feh --bg-scale /home/adam/.wallpapers/bg1.jpg &
xrdb -merge $HOME/.Xresources 
xmodmap $HOME/.Xmodmap &
setxkbmap -layout cz,us -option grp:alt_caps_toggle -option caps:swapescape -option terminate:ctrl_alt_bksp &
numlockx &
pulseaudio --start &

while true;
do
	xsetroot -name "$(pulseaudio-ctl current) | $(date "+%a %d. %m. | %T")"
	sleep 1
done &
exec dwm
