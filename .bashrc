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
export PATH="/home/adam/bin:/home/adam/scripts:/home/adam/.fzf/bin:$PATH"

eval $(dircolors -b /home/adam/.dircolors)

export PS1=' \[$(tput sgr0)\]\[\033[38;5;166m\]\u\[$(tput sgr0)\]\[\033[38;5;244m\]@\[$(tput sgr0)\]\[\033[38;5;217m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput bold)\]\[\033[38;5;155m\]\W\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;244m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]'

export FZF_DEFAULT_COMMAND='fd --absolute-path --no-ignore --type file --color=always --follow --hidden --exclude .git|.trash "" /home/adam'
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# program aliases
alias v='nvim'
alias sv='sudo nvim'
alias r='lf'
alias sr='sudo lf'
alias f='fzf'
alias ls='ls --color=auto'
alias i='sudo xbps-install'
alias s='sudo xbps-query -Rs'
alias q='sudo xbps-query -l'
alias u='sudo xbps-remove'
alias au='pulsemixer'
alias bl='bluetoothctl'
alias mke='sudo make clean install'
alias !!='sudo !!'
alias tr='transmission-remote'
alias scan='scanimage >'
alias gpom='git pull origin master'
alias lp='lp -o fit-to-page'
alias lpdupl='lp -o fit-to-page -o sides=two-sided-long-edge'
alias lpdups='lp -o fit-to-page -o sides=two-sided-short-edge'
alias tlin='sudo tlmgr install'

# directories aliases
alias gst='cd /home/adam/builds/st'
alias cst='cd /home/adam/builds/st && v config.h'
alias gdwm='cd /home/adam/builds/dwm'
alias cdwm='cd /home/adam/builds/dwm && v config.h'
alias gv='cd /home/adam/.config/nvim'
alias cv='cd /home/adam/.config/nvim && v init.vim'
alias gq='cd /home/adam/.config/qutebrowser'
alias cq='cd /home/adam/.config/qutebrowser && v config.py'
alias gb='cd /home/adam'
alias cb='cd /home/adam && v .bashrc'
alias glf='cd /home/adam/.config/lf'
alias clf='cd /home/adam/.config/lf && v lfrc'
alias gmu='cd /home/adam/.config/mutt'
alias cmu='cd /home/adam/.config/mutt && v muttrc'
alias gr='cd /'
alias gse='cd /var/service'
alias gsv='cd /etc/sv/services'
alias gh='cd /home/adam'
alias gc='cd /home/adam/.config'
alias ge='cd /etc'
alias gu1='cd /mnt/usb1'
alias gu2='cd /mnt/usb2'
alias gu3='cd /mnt/usb3'
alias gi='cd /home/adam/.install'
alias ci='cd /home/adam/.install && v programs'
alias gb='cd /home/adam/builds'
alias gdo='cd /home/adam/downloads'
alias gdr='cd /home/adam/drive'
alias gsk='cd /home/adam/drive/skola'
alias gsa='cd /home/adam/drive/skaut'
alias gan='cd /home/adam/drive/skola/anki'
alias gsot='cd /home/adam/soc/asteroidy_tex'
alias csot='cd /home/adam/soc/asteroidy_tex && v asteroidy.tex'
alias gsof='cd /home/adam/soc/swift_eunomia'
alias gM='cd /home/adam/drive/skola/matika'
alias gmi='cd /home/adam/drive/skola/matika/iKS'
alias gmk='cd /home/adam/drive/skola/matika/krouzek/2018-2019/'
alias gmo='cd /home/adam/drive/skola/matika/MO'
alias gmp='cd /home/adam/drive/skola/matika/prase'
alias gms='cd /home/adam/drive/skola/matika/sady'
alias gsc='cd /home/adam/scripts'
