# =============================================================================
#  1. Bootstrap
# =============================================================================

# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zinit
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Completion system
autoload -Uz compinit
compinit

# Zinit annexes
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# =============================================================================
#  2. Theme
# =============================================================================

zinit ice depth"1"
zinit light romkatv/powerlevel10k

# =============================================================================
#  3. Plugins
# =============================================================================

# --- Core ---
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# --- Useful ---
zinit light Aloxaf/fzf-tab
zinit light MichaelAquilina/zsh-you-should-use
zinit light z-shell/zsh-eza

# --- Oh-My-Zsh snippets ---
zinit snippet OMZP::archlinux
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::extract
zinit snippet OMZP::git
zinit snippet OMZP::systemadmin
zinit snippet OMZP::systemd

# =============================================================================
#  4. Environment
# =============================================================================

# --- PATH ---
export PATH=$HOME/.bin:$HOME/.local/bin:$PATH

# --- Editor ---
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# --- nvm ---
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- Secrets ---
[[ -f ~/.secrets ]] && source ~/.secrets

# =============================================================================
#  5. Tool integrations (eval / completions)
# =============================================================================

# --- fzf ---
eval "$(fzf --zsh)"

# --- zoxide ---
eval "$(zoxide init zsh)"

# --- atuin ---
ATUIN_PATH="$HOME/.atuin/bin"
if [ -d "$ATUIN_PATH" ]; then
  export PATH="$ATUIN_PATH:$PATH"
  eval "$(atuin init zsh)"
fi

# --- uv ---
eval "$(uv generate-shell-completion zsh)"

# --- thefuck ---
eval $(thefuck --alias)

# =============================================================================
#  6. Aliases
# =============================================================================

# --- Navigation ---
mkcd() { mkdir -p "$1" && cd "$1" }

# --- yt-dlp ---
yt() {
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

    noglob yt-dlp -o "$output" "${extra_args[@]}"
}

# --- Trashy ---
alias tp='trashy put'
alias tl='trashy list'
alias tR='trashy restore'
alias te='trashy empty'

# --- Cloud ---
alias gdrive-sync='rclone bisync ~/Documents/gdrive gdrive:/ --progress'
alias gdrive-test='rclone bisync ~/Documents/gdrive gdrive:/ --progress --dry-run'

# --- Config quick edit ---
alias zshrc='$EDITOR ~/.zshrc'
alias zshr='source ~/.zshrc'

# =============================================================================
#  7. Functions
# =============================================================================

# Sound notifier: run after a long command to get audio feedback
oks() {
    local s=$?
    local sound_success="/usr/share/sounds/freedesktop/stereo/complete.oga"
    local sound_error="/usr/share/sounds/freedesktop/stereo/suspend-error.oga"

    if [[ $s -eq 0 ]]; then
        echo "[✔] SUCCESS"
        [[ -f "$sound_success" ]] && paplay "$sound_success"
    else
        echo "[!] ERROR: $s"
        [[ -f "$sound_error" ]] && paplay "$sound_error"
    fi
}

# Yazi: provides the ability to change the current working directory when exiting Yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
  command rm -f -- "$tmp"
}

# =============================================================================
#  8. Completion styling
# =============================================================================

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'ls --color $realpath'

# =============================================================================
#  9. Prompt
# =============================================================================

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# =============================================================================
# 10. Keybindings
# =============================================================================

# bindkey -e  # Emacs mode
# bindkey -v  # Vi mode
