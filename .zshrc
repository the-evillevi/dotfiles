# -------------------------------------------------------------------
# PATH
# -------------------------------------------------------------------

# Zsh exposes PATH as an array named `path`. Updating the array is less
# error-prone than manually editing the colon-separated string.
typeset -U path PATH

path_append() {
  [[ -d "$1" ]] || return 0
  path+=("$1")
}

path_prepend() {
  [[ -d "$1" ]] || return 0
  path=("$1" $path)
}

# User-installed Go binaries.
path_append "$HOME/go/bin"

# pnpm installs global binaries here on macOS.
export PNPM_HOME="$HOME/Library/pnpm"
path_prepend "$PNPM_HOME/bin"

# -------------------------------------------------------------------
# Default editor
# -------------------------------------------------------------------

export EDITOR="nvim"
export VISUAL="nvim"

# -------------------------------------------------------------------
# Shell history
# -------------------------------------------------------------------
# Persists command history across sessions, shares history between
# running shells, and appends new entries immediately (avoids losing
# history when multiple shells are open). Duplicate consecutive
# entries are not stored.

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=$HISTSIZE
setopt SHARE_HISTORY INC_APPEND_HISTORY HIST_IGNORE_DUPS

# -------------------------------------------------------------------
# Tab completion
# -------------------------------------------------------------------
# Initializes zsh's built-in completion system. The zstyle blocks
# enable an interactive menu for ambiguous completions and apply
# LS_COLORS to completion listings.

autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# -------------------------------------------------------------------
# Shell options
# -------------------------------------------------------------------
#   autocd      -- cd by typing a directory path alone
#   extendedglob -- enables advanced glob patterns (**/, ^, ~)
#   correct     -- suggests corrections for mistyped commands
#   notify      -- reports background job status immediately

setopt autocd extendedglob correct notify

# -------------------------------------------------------------------
# fzf (fuzzy finder)
# -------------------------------------------------------------------
# Binds Ctrl+R (fuzzy history search), Ctrl+T (fuzzy file path
# insertion), and Alt+C (fuzzy directory navigation). Also enables
# fuzzy completions for commands like kill, ssh, and export.

export FZF_DEFAULT_OPTS="
	--height 40%
	--layout=reverse
	--border
"

if command -v bat >/dev/null; then
  export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS}
	--preview 'bat --style=numbers --color=always {}'"
fi

if command -v fzf >/dev/null; then
  source <(fzf --zsh)
fi

# -------------------------------------------------------------------
# Prompt
# -------------------------------------------------------------------

if command -v starship >/dev/null; then
  eval "$(starship init zsh)"
fi

# -------------------------------------------------------------------
# Directory navigation (zoxide)
# -------------------------------------------------------------------
# Replaces cd with a frecency-based jump tool. Frequently accessed
# directories can be reached by typing fragments of their path.

if command -v zoxide >/dev/null; then
  eval "$(zoxide init zsh)"
fi

# -------------------------------------------------------------------
# uv and uvx, enable shell autocompletion
# -------------------------------------------------------------------

if command -v uv >/dev/null; then
  eval "$(uv generate-shell-completion zsh)"
fi

if command -v uvx >/dev/null; then
  eval "$(uvx --generate-shell-completion zsh)"
fi

# -------------------------------------------------------------------
# Aliases
# -------------------------------------------------------------------

# Catches accidental use of npm and redirects to pnpm with a warning.
alias npm="echo 'Use pnpm instead!' >&2 && pnpm"

# Replaces ls with eza, always showing detailed format and hidden files.
alias ls="eza -lah --icons"

# Automatically show add/delte/changed colors in diffs
alias diff="diff --color=auto"

# -------------------------------------------------------------------
# Plugins
# -------------------------------------------------------------------

if command -v brew >/dev/null; then
  brew_prefix="$(brew --prefix 2>/dev/null)"

  # syntax hightlighting: https://github.com/zsh-users/zsh-syntax-highlighting/
  [[ -r "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
    source "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

  # autosuggestions: https://github.com/zsh-users/zsh-autosuggestions/
  [[ -r "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
    source "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

  # history substring search: https://github.com/zsh-users/zsh-history-substring-search
  if [[ -r "$brew_prefix/share/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
    source "$brew_prefix/share/zsh-history-substring-search/zsh-history-substring-search.zsh"
    bindkey "^[[A" history-substring-search-up
    bindkey "^[[B" history-substring-search-down
    export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true
  fi

  unset brew_prefix
fi
