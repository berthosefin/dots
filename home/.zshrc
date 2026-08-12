# ==============================================================
# 1. ENVIRONMENT
# ==============================================================
export EDITOR="nvim"

# PATH
export PATH="$HOME/.local/bin:$HOME/.bin:$PATH"

# ==============================================================
# 2. HISTORY
# ==============================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY        # record command timestamp + duration
setopt HIST_EXPIRE_DUPS_FIRST  # evict duplicates first when history is full
setopt HIST_IGNORE_DUPS        # ignore consecutive duplicates
# setopt HIST_IGNORE_ALL_DUPS    # remove older duplicates from the whole history
setopt HIST_IGNORE_SPACE       # commands prefixed with a space are not recorded
setopt HIST_VERIFY             # show the command before running it after !!
# setopt SHARE_HISTORY           # share history across open sessions
setopt INC_APPEND_HISTORY      # write each command immediately, not on shell exit

# ==============================================================
# 3. KEYBINDINGS
# ==============================================================

# Emacs mode
# bindkey -e

# Vi mode
bindkey -v
export KEYTIMEOUT=5   # reduce the delay after Escape (default 400ms, annoying)

# Cursor changes shape depending on mode (bar in insert, block in normal)
function zle-keymap-select() {
  case $KEYMAP in
    vicmd)
      echo -ne '\e[1 q' ;;  # blinking block
    viins|main)
      echo -ne '\e[5 q' ;;  # blinking bar
  esac
}
zle -N zle-keymap-select
echo -ne '\e[5 q' # bar on shell startup

# Ctrl+A / Ctrl+E work even in vim mode (lost by default)
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line

# ==============================================================
# 4. ZAP — plugin manager
# ==============================================================
[ -f "${ZAP_DIR:-$HOME/.local/share/zap}/zap.zsh" ] && source "${ZAP_DIR:-$HOME/.local/share/zap}/zap.zsh"

plug "zsh-users/zsh-completions"

# Required: initialize the zsh completion engine (compinit).
autoload -Uz compinit
compinit

plug "Aloxaf/fzf-tab"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"   # must stay the LAST plugin loaded

# ==============================================================
# 5. TOOL INTEGRATIONS
# ==============================================================
# Shell init scripts, key bindings and completions for external tools.
# Add a new tool as its own block below.
# IMPORTANT: atuin must stay the LAST block (overrides Ctrl+R and the up arrow).

# starship (prompt)
eval "$(starship init zsh)"

# fnm (node version manager)
eval "$(fnm env --use-on-cd --shell zsh)"

# fzf (Ctrl+T files / Ctrl+R history)
source <(fzf --zsh)

# zoxide (smart cd)
eval "$(zoxide init zsh)"

# uv (Python tool manager)
eval "$(uv generate-shell-completion zsh)"

# uvx (uv runner)
eval "$(uvx --generate-shell-completion zsh)"

# bun (JS runtime + completions)
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[[ -s "$BUN_INSTALL/_bun" ]] && source "$BUN_INSTALL/_bun"

# atuin (history UI) — MUST stay last
eval "$(atuin init zsh)"

# ==============================================================
# 6. ALIASES
# ==============================================================

# Config quick edit
alias zshrc='$EDITOR ~/.zshrc'
alias zshr='source ~/.zshrc'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# eza
alias ls='eza --group-directories-first --icons=auto'
alias la='eza -a --group-directories-first --icons=auto'
alias ll='eza -lah --group-directories-first --icons=auto'
alias lt='eza --tree --level=2 --icons=auto'

# systemctl
alias sc='sudo systemctl'
alias scu='systemctl --user'

# Git
alias gst='git status'
alias glog='git log --oneline --graph --decorate'
alias lg='lazygit'

# Trashy
alias tp='trashy put'
alias tl='trashy list'
alias tR='trashy restore'
alias te='trashy empty'

# Cloud
alias gdrive-sync='rclone bisync ~/Documents/gdrive gdrive:/ --progress'
alias gdrive-test='rclone bisync ~/Documents/gdrive gdrive:/ --progress --dry-run'

# ==============================================================
# 7. USEFUL FUNCTIONS
# ==============================================================

# Yazi: provides the ability to change the current working directory when exiting Yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}

# mkcd: create a directory and cd into it
function mkcd() {
    [[ -z "$1" ]] && return 1
    mkdir -p -- "$1" && builtin cd -- "$1"
}

# yt-dlp
function yt() {
    local format="bestvideo+bestaudio/best"
    local output="%(title)s.%(ext)s"
    local extra_args=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --mp3)    extra_args+=(-x --audio-format mp3) ;;
            --480)    extra_args+=(-S res:480) ;;
            --720)    extra_args+=(-S res:720) ;;
            --1080)   extra_args+=(-S res:1080) ;;
            --pl)     output="%(playlist_index)s-%(title)s.%(ext)s" ;;
            --fc)     extra_args+=(--cookies-from-browser firefox) ;;
            *)        extra_args+=("$1") ;;
        esac
        shift
    done

    noglob yt-dlp -f "$format" -o "$output" "${extra_args[@]}"
}
