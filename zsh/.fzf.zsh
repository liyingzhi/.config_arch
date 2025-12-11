# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Using highlight (http://www.andre-simon.de/doku/highlight/en/highlight.html)
# https://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color="fg:#f0f0f0,bg:#252c31,bg+:#005f5f,hl:#87d75f,gutter:#252c31"
--color="query:#ffffff,prompt:#f0f0f0,pointer:#dfaf00,marker:#00d7d7"
--bind="ctrl-y:execute(readlink -f {} | echo -n {2..} | xclip -selection clipboard)"
--bind="ctrl-alt-y:execute-silent(xclip -selection clipboard {})"
'

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND='fd --type f'
export FZF_ALT_C_COMMAND='fd --type d'


# bind '"\C-x": "\C-r\C-m"'
# bind '"\ex": "\C-r\C-m"'
bindkey -s '^[x' '^R^M'
