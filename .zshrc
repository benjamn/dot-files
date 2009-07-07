# history
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=1000
setopt appendhistory autocd extendedglob

# default apps
(( ${+BROWSER} )) || export BROWSER="w3m"
(( ${+PAGER} ))   || export PAGER="less"

# prompt (if running screen, show window #)
if [ x$WINDOW != x ]; then
    export PS1="$WINDOW:%~%# "
else
    export PS1='%~ %# '
fi

# format titles for screen and rxvt
function title() {
  # escape '%' chars in $1, make nonprintables visible
    a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
    a=$(print -Pn "%40>...>$a" | tr -d "\n")

    case $TERM in
	screen)
	    print -Pn "\ek$a:$3\e\\"      # screen title (in ^A")
	    ;;
	xterm*|rxvt)
	    print -Pn "\e]2;$2 | $a:$3\a" # plain xterm title
	    ;;
    esac
}

# precmd is called just before the prompt is printed
function precmd() {
    title "zsh" "$USER@%m" "%55<...<%~"
}

# preexec is called just before any command line is executed
function preexec() {
    title "$1" "$USER@%m" "%35<...<%~"
}

# colorful listings
zmodload -i zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

autoload -U compinit
compinit

# aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias j=jobs
if ls -FG --color=auto >&/dev/null; then
    alias ls="ls --color=auto -FG"
else
    alias ls="ls -FG"
fi
alias ll="ls -l"
alias l.='ls -d .[^.]*'
alias lsd='ls -ld *(-/DN)'
alias md='mkdir -p'
alias rd='rmdir'
alias cd..='cd ..'
alias ..='cd ..'
alias po='popd'
alias pu='pushd'
alias tsl="tail -f /var/log/syslog"
alias df="df -hT"
alias em="emacs -nw"

alias psrc='pushd `pwd | sed "s/\/obj-ff//"`'

tunnel() {
    TUNNEL="ssh -D ${2:-8080} -f -C -q -N"

    ps aux | \
        grep $TUNNEL | \
        grep -v grep | \
        awk '{print $2}' | \
        xargs kill

    case $1 in
    xenon)
        eval "$TUNNEL benjamin@xenon.stanford.edu"
        ;;
    esac
}

abs() {
    local rel=${1:-.}
    local p
    if [ -d $rel ]
    then
        pushd $rel > /dev/null
        p=`pwd`
        popd > /dev/null
    else
        pushd `dirname $rel` > /dev/null
        p=`pwd`/`basename $rel`
        popd > /dev/null
    fi
    echo $p
}

source .zsh_hg_cmds

# functions
mdc() { mkdir -p "$1" && cd "$1" }
setenv() { export $1=$2 }  # csh compatibility
sdate() { date +%Y.%m.%d }
pc() { awk "{print \$$1}" }
rot13 () { tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]" }

# shuffle input lines. Nice for mp3 playlists etc...
shuffle() {
    RANDOM=`date +%s`
    (
	while IFS= read -r i; do
	    echo $RANDOM$RANDOM "$i";
	done
	) | sort | sed 's/^[0-9]* //'
}
