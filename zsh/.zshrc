# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-autosuggestions
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

source $ZSH/custom/plugins/wdx/wdx.zsh

#### wdx
if command -v wdx &>/dev/null; then
    alias wd='wdx'
    alias ws='wdx set'
    alias wsf='wdx set -f'
fi

# 改用 Ctrl+Space 完全接受建议
bindkey '^ ' autosuggest-accept

### Filesystem management

#### cp, mv, ln

# You can "copy" any number of files, then "paste", "move" or
# "pasteln" them to pass them as arguments to cp, mv, or ln
# respectively. Just like a graphical filesystem manager. Each of the
# latter three functions defaults to the current directory as the
# destination.

# Usage: copy <path>...
#
# Copy all of the paths provided to the clipboard, stored in the array
# $RADIAN_CLIPBOARD.
function copy {
    emulate -LR zsh
    RADIAN_CLIPBOARD=()
    for target; do
        RADIAN_CLIPBOARD+=(${target:a})
    done
}

# Usage: paste [<path>]
#
# Invoke 'cp -R' on all paths in $RADIAN_CLIPBOARD as well as the
# argument provided, which defaults to the current directory.
function paste {
    emulate -LR zsh
    cp -R $RADIAN_CLIPBOARD ${1:-.}
}

# Usage: move [<path>]
#
# Invoke 'mv' on all paths in $RADIAN_CLIPBOARD as well as the
# argument provided, which defaults to the current directory.
function move {
    emulate -LR zsh
    mv $RADIAN_CLIPBOARD ${1:-.}
}

# Usage: pasteln [<path>]
#
# Invoke 'ln -s' on all paths in $RADIAN_CLIPBOARD as well as the
# argument provided, which defaults to the current directory.
function pasteln {
    emulate -LR zsh
    ln -s $RADIAN_CLIPBOARD ${1:-.}
}

# Usage: delink <path>
#
# Resolve the symlink at the given path and replace it with a copy of
# the file it points to.
function delink {
    emulate -LR zsh
    if [[ -z $1 ]]; then
        echo >&2 "usage: delink <symlinks>"
        return 1
    fi
    for link; do
        if [[ -L $link ]]; then
            if [[ -e $link ]]; then
                target=${link:A}
                if rm $link; then
                    if cp -R $target $link; then
                        echo >&2 "Copied $target to $link"
                    else
                        ln -s $target $link
                    fi
                fi
            else
                echo >&2 "Broken symlink: $link"
            fi
        else
            echo >&2 "Not a symlink: $link"
        fi
    done
}

# Usage: transpose <path1> <path2>
#
# Swap the files or directories at the two provided paths. Not atomic.
# Both paths must exist.
function transpose {
    emulate -LR zsh
    if (( $# != 2 )); then
        echo >&2 "usage: transpose <path1> <path2>"
        return 1
    fi
    for arg in $1 $2; do
        if [[ ! -e $arg && ! -L $arg ]]; then
            echo >&2 "no such file or directory: $arg"
            return 1
        fi
        if [[ -e $path.tmp || -L $path.tmp ]]; then
            echo >&2 "already exists: $path.tmp"
            return 1
        fi
    done
    mv $1 $1.tmp
    mv $2 $2.tmp
    mv $1.tmp $2
    mv $2.tmp $1
}

## Aliases

#### dirs

# This alias is a convenient way to list the last few directories
# visited, with their numbers. You can then use the 'cd -n' aliases to
# jump to those directories.
alias ds='dirs -v | head -10'


#### mkdir

alias md='mkdir -p'

function mcd {
    emulate -LR zsh
    mkdir -p $@
    cd ${@[$#]}
}

compdef _mkdir mcd


### Utilities
#### Docker

if (( $+commands[docker] )); then
    alias dr='docker run -it --rm'
fi

#### Emacs

if (( $+commands[emacs] )); then
    alias e='emacs -nw'
    alias eq='emacs -nw -Q'
    alias ew='emacs'
    alias eqw='emacs -Q'
    alias ue='USER_EMACS_DIRECTORY=$PWD e'
    alias uew='USER_EMACS_DIRECTORY=$PWD ew'
fi

if (( $+commands[emacsclient] )); then
    alias ec='emacsclient --alternate-editor= -nw'
    alias ecw='emacsclient --alternate-editor='
fi


#### ls, eza
unalias l &>/dev/null

if (( $+commands[eza] )); then

    function l {
        emulate -LR zsh
        eza --all --header --long --color-scale=all $@
    }

    function lg {
        emulate -LR zsh
        l --grid $@
    }

    function lt {
        emulate -LR zsh
        l --tree --ignore-glob ".git|.svn|node_modules" $@
    }

    function lti {
        emulate -LR zsh
        l --tree --ignore-glob ".git|.svn|node_modules|$1" ${@:2}
    }

    function ltl {
        emulate -LR zsh
        lt --level $@
    }

    function ltli {
        l --tree --level $1 --ignore-glob ".git|.svn|node_modules|$2" ${@:3}
    }

else

    # We alias gls to a git command elsewhere, so we use "command"
    # here to prevent it from being interpreted as said git command.
    if (( $+commands[gls] )); then
        alias l='command gls -AlhF --color=auto'
    else
        alias l='ls -AlhF'
    fi
    if (( $+commands[tree] )); then
        alias lt='tree -a'
        alias ltl='tree -aL'
    fi
fi

# Set up fzf key bindings and fuzzy completion
# source <(fzf --zsh)
if [ -f ~/.fzf.zsh ]; then
    . ~/.fzf.zsh
fi

# alias eza="eza --icons=auto --hyperlink --color=always --color-scale=all --color-scale-mode=gradient --git --git-repos"
# alias ls="eza"
# alias ls='ls --color=auto'
alias miniemacs='emacs --init-directory=/home/ii/mini-emacs/'
alias grep='grep --color=auto'
alias archupdate="$HOME/github/scripts/archupdate"

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias lzd='lazydocker'
