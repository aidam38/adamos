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
export VISUAL="kak"
export EDITOR="kak"
# export VISUAL="nvim"
# export EDITOR="nvim"
export OPENER="mimeopen"
export PATH="/home/adam/.bin:/home/adam/scripts:/home/adam/.fzf/bin:$PATH"

eval $(dircolors -b /home/adam/.dircolors)

export PS1=' \[$(tput sgr0)\]\[\033[38;5;166m\]\u\[$(tput sgr0)\]\[\033[38;5;244m\]@\[$(tput sgr0)\]\[\033[38;5;217m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput bold)\]\[\033[38;5;155m\]\W\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;244m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]'

export FZF_DEFAULT_COMMAND='fd --absolute-path --no-ignore-vcs --type file --color=always --follow  --exclude .trash --search-path /home/adam --search-path /home/adam/.config'
#export FZF_DEFAULT_COMMAND='fd --absolute-path --color=always --follow'
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export GOPATH="/home/adam/.go"

# program aliases
alias v='nvim'
alias suv='sudo nvim'
alias r='lf'
alias sr='sudo lf'
alias f='fzf'
alias ls='ls --color=auto'
alias z='zathura'
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
alias gplom='git pull origin master'
alias gpsom='git push origin master'
alias lp='lp -o fit-to-page'
alias lpdupl='lp -o fit-to-page -o sides=two-sided-long-edge'
alias lpdups='lp -o fit-to-page -o sides=two-sided-short-edge'
alias tlin='sudo tlmgr install'

# directories aliases
alias gst='cd /home/adam/builds/st'
alias cst='cd /home/adam/builds/st && $EDITOR config.h'
alias gdwm='cd /home/adam/builds/dwm'
alias cdwm='cd /home/adam/builds/dwm && $EDITOR config.h'
alias gv='cd /home/adam/.config/nvim'
alias cv='cd /home/adam/.config/nvim && $EDITOR init.vim'
alias gk='cd /home/adam/.config/kak'
alias ck='cd /home/adam/.config/kak && $EDITOR kakrc'
alias gq='cd /home/adam/.config/qutebrowser'
alias cq='cd /home/adam/.config/qutebrowser && $EDITOR config.py'
alias gb='cd /home/adam'
alias cb='cd /home/adam && $EDITOR .bashrc'
alias gx='cd /home/adam'
alias cx='cd /home/adam && $EDITOR .xinitrc'
alias glf='cd /home/adam/.config/lf'
alias clf='cd /home/adam/.config/lf && $EDITOR lfrc'
alias gmu='cd /home/adam/.config/mutt'
alias cmu='cd /home/adam/.config/mutt && $EDITOR muttrc'
alias gal='cd /home/adam/scripts'
alias cal='cd /home/adam/scripts && $EDITOR aliases'
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
alias ci='cd /home/adam/.install && $EDITOR programs'
alias gb='cd /home/adam/builds'
alias gdo='cd /home/adam/downloads'
alias gdr='cd /home/adam/drive'
alias gsk='cd /home/adam/drive/skola'
alias gsa='cd /home/adam/drive/ostatni/skaut/2018-2019'
alias gan='cd /home/adam/drive/skola/anki'
alias gsot='cd /home/adam/soc/asteroidy_tex'
alias csot='cd /home/adam/soc/asteroidy_tex && $EDITOR asteroidy.tex'
alias gsof='cd /home/adam/soc/swift_eunomia'
alias gM='cd /home/adam/drive/skola/matika'
alias gmi='cd /home/adam/drive/skola/matika/iKS/2018-2019'
alias gmk='cd /home/adam/drive/skola/matika/krouzek/2018-2019/'
alias gmo='cd /home/adam/drive/skola/matika/MO'
alias gmp='cd /home/adam/drive/skola/matika/prase/2018-2019'
alias gms='cd /home/adam/drive/skola/matika/sady'
alias gol='cd /home/adam/drive/skola/olympiady'
alias gfo='cd /home/adam/drive/skola/olympiady/FO/2018-2019'
alias gao='cd /home/adam/drive/skola/olympiady/AO/2018-2019'
alias gsc='cd /home/adam/scripts'
alias gů='cd /home/adam/soc/swift_eunomia/eunomia_data/chi2'
