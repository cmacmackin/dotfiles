#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Variables
export BROWSER="chromium"
export EDITOR="emacs"
export PAGER="less"

## Modified commands ## {{{
alias grep='grep --color=auto'
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias nano='nano -w'
alias ping='ping -c 5'
#alias emacs='emacs &> /dev/null'
alias evince='evince &> /dev/null'
alias gedit='gedit &> /dev/null'
# }}}

## New commands ## {{{
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias hist='history | grep'         # requires an argument
alias openports='ss --all --numeric --processes --ipv4 --ipv6'
alias pgg='ps -Af | grep'           # requires an argument
alias ..='cd ..'
# }}}

# Privileged access
if [ $UID -ne 0 ]; then
    alias sudo='sudo '
    alias scat='sudo cat'
    alias semacs='sudoedit'
    alias root='sudo -s'
#   alias reboot='sudo systemctl reboot'
#   alias poweroff='sudo systemctl poweroff'
#   alias update='sudo pacman -Su'
#   alias netctl='sudo netctl'
fi

## ls ## {{{
alias ls='ls -hF --color=auto'
alias lr='ls -R'                    # recursive ls
alias ll='ls -l'
alias la='ll -A'
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date
alias lm='la | more'
# }}}

## Safety features ## {{{
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'                    # 'rm -i' prompts for every file
# safer alternative w/ timeout, not stored in history
alias rm=' timeout 3 rm -Iv --one-file-system'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias cls=' echo -ne "\033c"'       # clear screen for real (it does not work in Terminology)
# }}}

# My aliases
alias go="gnome-open &> /dev/null"
alias len='wc -l'
alias syncup='rsync -zvr -P --delete -C'

# Window title
case $TERM in
  termite|*xterm*|rxvt|rxvt-unicode|rxvt-256color|rxvt-unicode-256color|(dt|k|E)term)
    precmd () {
      #vcs_info
      print -Pn "\e]0;[%n@%M][%~]%#\a"
    } 
    preexec () { print -Pn "\e]0;[%n@%M][%~]%# ($1)\a" }
    ;;
  screen|screen-256color)
    precmd () { 
      vcs_info
      print -Pn "\e]83;title \"$1\"\a" 
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~]\a" 
    }
    preexec () { 
      print -Pn "\e]83;title \"$1\"\a" 
      print -Pn "\e]0;$TERM - (%L) [%n@%M]%# [%~] ($1)\a" 
    }
    ;; 
esac


# Code to ensure virtualenv shows up properly in prompt
activate() {
  export VIRTUAL_ENV_DISABLE_PROMPT='1'
  if [ -d $1 ]; then;
    source $1/bin/activate
  elif [ -d ./$1 ]; then;
    source ./$1/bin/activate
  else
    echo "activate: no such file or directory: $1"
  fi
}

function virtualenv_info() {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function parse_git_branch() {
	if [[ -f "$BASH_COMPLETION_DIR/git-completion.bash" ]]; then
		branch=`__git_ps1 "%s"`
	else
		ref=$(git-symbolic-ref HEAD 2> /dev/null) || return
		branch="${ref#refs/heads/}"
	fi

	if [[ `tput cols` -lt 110 ]]; then
		branch=`echo $branch | sed s/feature/f/1`
		branch=`echo $branch | sed s/hotfix/h/1`
		branch=`echo $branch | sed s/release/\r/1`

		branch=`echo $branch | sed s/master/mstr/1`
		branch=`echo $branch | sed s/develop/dev/1`
	fi

	if [[ $branch != "" ]]; then
		if [[ $(git status 2> /dev/null | tail -n1) == "nothing to commit, working directory clean" ]]; then
			echo "%{$fg[green]%}$branch%{$reset_color%} "
		else
			echo "%{$fg[red]%}$branch%{$reset_color%} "
		fi
	fi
}

# Sets prompt to custom
autoload -U colors && colors
PROMPT='┌─%B%{$fg[green]%}%n@%M %{$fg[red]%}$(virtualenv_info )%{$fg[blue]%}%~ $(parse_git_branch)%b
%{$reset_color%}└─╼ %B%{$fg[blue]%}$%b '

# Environment variabilities for Fortran
export PFUNIT=/opt/pfunit-gfortran-5
export F90_VENDOR=GNU
export F90=gfortran-5
export FORTPY_CONFIG="$HOME/.emacs.d/fortpy-config.xml"

# Activate my main virtual environment
PATH=$PATH:~/.local/bin

# Add local path for libraries
export LS_LIBRARY_PATH=$HOME/.local/lib
export LOCAL_ROOT=$HOME/.local

alias plantuml="java -jar ~/Code/plantuml-markdown/plantuml.jar"
