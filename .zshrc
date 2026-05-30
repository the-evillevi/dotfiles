# -------------------------------------------------------------------
# PATH
# -------------------------------------------------------------------

# Appends Go binary directory to PATH if not already present.
# The guard prevents PATH from growing indefinitely on repeated sourcing.
[[ :$PATH: == *":$HOME/go/bin:"* ]] || export PATH=$PATH:$HOME/go/bin

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

source <(fzf --zsh)

export FZF_DEFAULT_OPTS="
	--height 40%
	--layout=reverse
	--border
	--preview 'bat --style=numbers --color=always {}'
"

# -------------------------------------------------------------------
# Prompt
# -------------------------------------------------------------------

eval "$(starship init zsh)"

# -------------------------------------------------------------------
# Directory navigation (zoxide)
# -------------------------------------------------------------------
# Replaces cd with a frecency-based jump tool. Frequently accessed
# directories can be reached by typing fragments of their path.

eval "$(zoxide init zsh)"

# -------------------------------------------------------------------
# uv and uvx, enable shell autocompletion
# -------------------------------------------------------------------

eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

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

# syntax hightlighting: https://github.com/zsh-users/zsh-syntax-highlighting/
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# autosuggestions: https://github.com/zsh-users/zsh-autosuggestions/
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# history substring search: https://github.com/zsh-users/zsh-history-substring-search
source "$(brew --prefix)/share/zsh-history-substring-search/zsh-history-substring-search.zsh"

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true

# pnpm
export PNPM_HOME="/Users/evillevi/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
