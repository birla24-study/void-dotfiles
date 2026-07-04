# --- History Settings ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY       # Share history across all active sessions
setopt HIST_IGNORE_DUPS    # Don't record duplicate entries

# --- Advanced Autocompletion ---
# Enable case-insensitive tab completion and interactive menu layout (replaces bash readline binds)
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive matching
zstyle ':completion:*' menu select                        # Interactive menu via arrow keys

# --- Keybindings for History Search ---
# Type part of a command and press Up/Down
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# --- Prompt ---
# Clean Zsh-native prompt (replacing bash-specific PS1)
PS1='[%n@%m %1~]%# '

# --- Environment Variables ---
# Trick Electron/Chromium apps into checking for libsecret backend
export XDG_CURRENT_DESKTOP=GNOME

# API keys
export GOOGLE_API_KEY="no"
export GOOGLE_DEFAULT_CLIENT_ID="no"
export GOOGLE_DEFAULT_CLIENT_SECRET="no"

# --- Aliases ---
alias ls='ls --color=auto'
alias ll='ls -la'
alias xi='sudo xbps-install'
alias xr='sudo xbps-remove'
alias yt='noglob yt-dlp -P ~/YouTube -f "399+bestaudio/bestvideo+bestaudio" --remux-video mkv --embed-metadata --embed-chapters --embed-thumbnail'
alias ff='fastfetch'
alias antigravity='/opt/Antigravity/bin/antigravity-ide'

# --- Load Plugins ---
# Must stay above the smart tab configuration
if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# --- Smart Tab Behavior ---
# Accepts gray text if present, otherwise opens normal completion menu
smart-tab() {
  if [[ -n "$POSTDISPLAY" ]]; then
    zle autosuggest-accept
  else
    zle expand-or-complete
  fi
}
zle -N smart-tab
bindkey '^I' smart-tab

# --- Startup Applications ---
# Automatically start Niri inside a D-Bus session on TTY1 (from .bash_profile)
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec dbus-run-session niri --session
fi
