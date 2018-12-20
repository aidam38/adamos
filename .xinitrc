#!/usr/bin/bash

compton -CG --no-fading-openclose --no-fading-destroyed-argb --focus-exclude "x = 0 && y = 0 && override_redirect = true" &
feh --bg-scale /home/adam/.wallpapers/bg.jpg &
xmodmap /home/adam/.Xmodmap &
setxkbmap -layout cz,us -option grp:alt_caps_toggle -option caps:swapescape -option terminate:ctrl_alt_bksp &
numlockx &
pulseaudio --start &
dunst &
redshift -l 49.1781233:16.5544039 &

while true; do
[[ $(pamixer --get-mute) == "true" ]] && xsetroot -name " M  | $(date "+%a %d. %m. | %T")" || xsetroot -name "$(pamixer --get-volume)% | $(date "+%a %d. %m. | %T")"
sleep 1
done &
exec dwm
