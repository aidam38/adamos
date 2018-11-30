# .bashrc of Adam Krivka (aidam38)

set -o vi
stty -ixon

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# append history
export HISTCONTROL=ignoredups:erasedups  
shopt -s histappend
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# global environment variables and colors
export VISUAL="nvim"
export EDITOR="nvim"
export OPENER="mimeopen"
export PATH="/home/adam/.scripts:/home/adam/scripts:/home/adam/.config/nvim/bundle/vim-live-latex-preview/bin:$PATH"

eval $(dircolors -b $HOME/.dircolors)

export PS1=" \[$(tput sgr0)\]\[\033[38;5;166m\]\u\[$(tput sgr0)\]\[\033[38;5;244m\]@\[$(tput sgr0)\]\[\033[38;5;217m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput bold)\]\[\033[38;5;155m\]\W\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;244m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

# program aliases
alias v='nvim'
alias sv='sudo nvim'
alias r='lf'
alias sr='sudo lf'
alias ls='ls --color=auto'
alias i='sudo xbps-install'
alias q='sudo xbps-query -Rs'
alias u='sudo xbps-remove'
alias y='yaourt'
alias au='pulsemixer'
alias bl='bluetoothctl'
alias mke='sudo make clean install'
alias !!='sudo !!'
alias tr='transmission-remote -w /home/adam/torrents -a'
alias trl='transmission-remote -l'
alias sc='scanimage >'
alias lp='lp -o fit-to-page'
alias lpdupl='lp -o fit-to-page -o sides=two-sided-long-edge'
alias lpdups='lp -o fit-to-page -o sides=two-sided-short-edge'
alias drive='cd ~/drive && grive -s School Skaut Karate Temp Random'

# directories aliases
alias gst='cd ~/builds/st'
alias cst='cd ~/builds/st && v config.h'
alias gdwm='cd ~/builds/dwm'
alias cdwm='cd ~/builds/dwm && v config.h'
alias gv='cd ~/.config/nvim'
alias cv='cd ~/.config/nvim && v init.vim'
alias gq='cd ~/.config/qutebrowser'
alias cq='cd ~/.config/qutebrowser && v config.py'
alias gb='cd ~'
alias cb='cd ~ && v .bashrc'
alias glf='cd ~/.config/lf'
alias clf='cd ~/.config/lf && v lfrc'
alias gr='cd /'
alias gh='cd ~'
alias ge='cd /etc'
alias gu='cd /mnt'
alias gb='cd ~/builds'
alias gdo='cd ~/downloads'
alias gde='cd ~/drive'
alias gsk='cd ~/drive/School'
alias gan='cd ~/drive/School/Anki'
alias gsod='cd ~/drive/School/SOC/tex'
alias gsof='cd ~/soc'
alias gM='cd ~/drive/School/Matika'
alias gmi='cd ~/drive/School/Matika/iKS'
alias gmk='cd ~/drive/School/Matika/Krouzek/2018-2019/'
alias gmm='cd ~/drive/School/Matika/MO'
alias gmp='cd ~/drive/School/Matika/PraSe'
alias gms='cd ~/drive/School/Matika/Sady'
alias gsc='cd ~/scripts'
