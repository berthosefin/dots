# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
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

# Initialize completion system early
autoload -Uz compinit
compinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# ----- Theme -----
# Load powerlevel10k theme
zinit ice depth"1" # git clone depth
zinit light romkatv/powerlevel10k

# ----- Plugins -----
# Essential plugins (priority loading)
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# Useful plugins
zinit light Aloxaf/fzf-tab
zinit light MichaelAquilina/zsh-you-should-use
zinit light z-shell/zsh-eza

# Oh-My-ZSH snippets
zinit snippet OMZP::archlinux
zinit snippet OMZP::colored-man-pages
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::extract
zinit snippet OMZP::git
zinit snippet OMZP::systemadmin
zinit snippet OMZP::systemd

# ----- Path -----
export PATH="$HOME/.bin:$HOME/.local/bin:$PATH"

# ----- Editor -----
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# ----- fnm (fast Node.js manager) -----
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ----- fzf -----
eval "$(fzf --zsh)"

# ----- zoxide -----
eval "$(zoxide init zsh)"

# ----- atuin -----
ATUIN_PATH="$HOME/.atuin/bin"
if [ -d "$ATUIN_PATH" ]; then
  export PATH="$ATUIN_PATH:$PATH"
  eval "$(atuin init zsh)"
fi

# ----- uv completions -----
eval "$(uv generate-shell-completion zsh)"

# ----- Pywal colors -----
(cat ~/.cache/wal/sequences &)

# ----- Custom aliases -----
alias yt-mp3="noglog yt-dlp -x --audio-format mp3 --cookies-from-browser firefox"
alias yt-480="noglob yt-dlp -S res:480 --cookies-from-browser firefox"
alias yt-720="noglob yt-dlp -S res:720 --cookies-from-browser firefox"
alias yt-p="noglob yt-dlp -o '%(playlist_index)s-%(title)s.%(ext)s' --cookies-from-browser firefox"
alias yt-mp3-nc="noglob yt-dlp -x --audio-format mp3"
alias yt-480-nc="noglob yt-dlp -S res:480"
alias yt-720-nc="noglob yt-dlp -S res:720"
alias yt-p-nc="noglob yt-dlp -o '%(playlist_index)s-%(title)s.%(ext)s'"

# ----- Quick edit configs -----
alias zshrc='$EDITOR ~/.zshrc'
alias zshr='source ~/.zshrc'

# ----- Quick directory creation and navigation -----
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ----- Ok sound notifier -----
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

# ----- Completion styling -----
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'ls --color $realpath'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
