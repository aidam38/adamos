# ~/.bash_profile

[[ -f ~/.bashrc ]] && . ~/.bashrc

sxhkd -c ~/.config/sxhkd/sxhkdrc -m 1 &

exec sway
# exec startx
