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
export TERM="st-256color"
export TERMINAL="st-256color"
export VISUAL="kak"
export EDITOR="kak"
# export PAGER="kak-pager"
# export MANPAGER="kak-man-pager"
export PAGER="less"
export MANPAGER="less"
export OPENER="mimeopen"
export PATH="/home/adam/.node_modules/bin:/home/adam/.bin:/home/adam/scripts:/home/adam/.fzf/bin:/home/adam/.cargo/bin:/home/adam/.go/bin:/usr/local/texlive/2019/bin/x86_64-linux:/root/.cargo/bin:$(du "$HOME/scripts/" | cut -f2 | tr '\n' ':' | sed 's/:*$//'):$PATH"
export XDG_CONFIG_HOME="/home/adam/.config"
export TEXMFHOME='~/.texmf'
export SUDO_ASKPASS="$HOME/.bin/dmenupass"
export $(dbus-launch)

eval $(dircolors -b /home/adam/.dircolors)

export PS1=' \[$(tput sgr0)\]\[\033[38;5;166m\]\u\[$(tput sgr0)\]\[\033[38;5;244m\]@\[$(tput sgr0)\]\[\033[38;5;217m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput bold)\]\[\033[38;5;155m\]\W\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]\[\033[38;5;244m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]'

export FZF_DEFAULT_COMMAND='fd --absolute-path --no-ignore-vcs --type file --color=always --follow  --exclude .trash --search-path /home/adam --search-path /home/adam/.config --search-path /home/adam/.bin'
#export FZF_DEFAULT_COMMAND='fd --absolute-path --color=always --follow'
export FZF_DEFAULT_OPTS="--ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export GOPATH="/home/adam/.go"

# program aliases
function lf-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    lf -last-dir-path="$tempfile" $*
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}
alias f='lf-cd'
alias sf='sudo lf-cd'
alias recaudio="parec --monitor-stream="$(pacmd list-sink-inputs | awk '$1 == "index:" {print $2}')" | opusenc --raw - recording-$(date +"%F_%H-%M-%S").opus"

alias v='nvim'
alias suv='sudo nvim'
alias k='kak'
alias suk='sudo kak'
alias fzf='fzf --ansi'
alias fd='fd --no-ignore-vcs --color=always'
alias ls='ls --color=auto'
alias z='zathura'
alias pandoc='pandoc --filter=pandoc-docx-pagebreakpy'

alias i='yay -S --noconfirm'
alias ii='yay -Syu --noconfirm'
alias s='yay -Ss'
alias l='yay -Q'
alias u='yay -Ru'
alias uu='yay -Rdd'

alias au='pulsemixer'
alias bl='bluetoothctl'
alias mke='sudo make clean install'
alias ...=". .bashrc"
# alias !!='sudo !!'
alias scan='scanimage >'
alias restartsxhkd='killall -SIGUSR1 sxhkd'

alias gplom='git pull origin master'
alias gpsom='git push origin master'
alias gcl='git clone'

alias lp='lp -o fit-to-page'
alias lpdupl='lp -o fit-to-page -o sides=two-sided-long-edge'
alias lpdups='lp -o fit-to-page -o sides=two-sided-short-edge'

alias tlin='sudo tlmgr install'

alias drup='rclone copy -LuP /home/adam/drive drive:'
alias drdown='rclone copy drive: /home/adam/drive -P --exclude SVČ*/ --drive-chunk-size 128M'
alias drclone='rclone sync -LuP /home/adam/drive drive:'
alias orup='rclone copy -LuP /home/adam/team_drives/or89 or89:'
alias orwn='rclone copy or89: /home/adam/team_drives/or89 -P --exclude SVČ*/ --drive-chunk-size 128M'
alias orclone='rclone sync -LuP /home/adam/team_drives/or89 or89:'

# source ~/.bash_bookmarks
