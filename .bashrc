# .bashrc of Adam Krivka (aidam38)

set -o vi
stty -ixon
shopt -s autocd

# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# append history
export HISTCONTROL=ignoredups:erasedups  
HISTSIZE= HISTFILESIZE=
shopt -s histappend
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# global environment variables and colors
export TERMINAL="st"
export VISUAL="kak"
export EDITOR="kak"
# export PAGER="kak-pager"
# export MANPAGER="kak-man-pager"
export PAGER="less"
export MANPAGER="less"
export OPENER="mimeopen"
export PATH="/home/adam/.bin:/home/adam/scripts:/home/adam/.fzf/bin:/home/adam/.cargo/bin:/home/adam/.go/bin/:~/.npm-global/bin:$PATH"
export XDG_CONFIG_HOME="/home/adam/.config"

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
alias f='lf'
alias sf='sudo lf'
# alias f='fzf'
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
alias gcl='git clone'
alias lp='lp -o fit-to-page'
alias lpdupl='lp -o fit-to-page -o sides=two-sided-long-edge'
alias lpdups='lp -o fit-to-page -o sides=two-sided-short-edge'
alias tlin='sudo tlmgr install'

# directories aliases
alias bst='cd /home/adam/builds/st'
alias Cst='cd /home/adam/builds/st && $EDITOR config.h'
alias bdwm='cd /home/adam/builds/dwm'
alias Cdwm='cd /home/adam/builds/dwm && $EDITOR config.h'
alias bv='cd /home/adam/.config/nvim'
alias Cv='cd /home/adam/.config/nvim && $EDITOR init.vim'
alias bk='cd /home/adam/.config/kak'
alias Ck='cd /home/adam/.config/kak && $EDITOR kakrc'
alias bq='cd /home/adam/.config/qutebrowser'
alias Cq='cd /home/adam/.config/qutebrowser && $EDITOR config.py'
alias bb='cd /home/adam'
alias Cb='cd /home/adam && $EDITOR .bashrc'
alias bx='cd /home/adam'
alias Cx='cd /home/adam && $EDITOR .xinitrc'
alias blf='cd /home/adam/.config/lf'
alias Clf='cd /home/adam/.config/lf && $EDITOR lfrc'
alias bmu='cd /home/adam/.config/mutt'
alias Cmu='cd /home/adam/.config/mutt && $EDITOR muttrc'
alias bal='cd /home/adam/scripts'
alias Cal='cd /home/adam/scripts && $EDITOR aliases'
alias bri='cd /home/adam/.config/ranger'
alias Cri='cd /home/adam/.config/ranger && $EDITOR rifle.conf'
alias bse='cd /var/service'
alias bsv='cd /etc/sv/services'
alias bh='cd /home/adam'
alias bc='cd /home/adam/.config'
alias be='cd /etc'
alias bu1='cd /mnt/usb1'
alias bu2='cd /mnt/usb2'
alias bu3='cd /mnt/usb3'
alias bi='cd /home/adam/.install'
alias Ci='cd /home/adam/.install && $EDITOR programs'
alias bb='cd /home/adam/builds'
alias bdo='cd /home/adam/downloads'
alias bdr='cd /home/adam/drive'
alias bsko='cd /home/adam/drive/skola'
alias bska='cd /home/adam/drive/skaut/2018-2019'
alias bpr='cd /home/adam/drive/prihlasky'
alias bka='cd /home/adam/drive/karate'
alias ban='cd /home/adam/drive/skola/anki'
alias bsot='cd /home/adam/soc/asteroidy_tex'
alias Csot='cd /home/adam/soc/asteroidy_tex && $EDITOR asteroidy.tex'
alias bsof='cd /home/adam/soc/swift_eunomia'
alias bM='cd /home/adam/drive/skola/matika'
alias bmi='cd /home/adam/drive/skola/matika/iKS/2018-2019'
alias bmk='cd /home/adam/drive/skola/matika/krouzek/2018-2019/'
alias bmo='cd /home/adam/drive/skola/matika/MO'
alias bmp='cd /home/adam/drive/skola/matika/prase/2018-2019'
alias bms='cd /home/adam/drive/skola/matika/sady'
alias bol='cd /home/adam/drive/skola/olympiady'
alias bfo='cd /home/adam/drive/skola/olympiady/FO/2018-2019'
alias bao='cd /home/adam/drive/skola/olympiady/AO/2018-2019'
alias bdb='cd /home/adam/.bin'
alias bsc='cd /home/adam/scripts'
alias bů='cd /home/adam/soc/swift_eunomia/eunomia_data/chi2'
