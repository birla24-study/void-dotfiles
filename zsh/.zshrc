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
alias xu='sudo xbps-install -Syu'
alias yt='noglob yt-dlp -P ~/YouTube -f "399+bestaudio/bestvideo+bestaudio" --remux-video mkv --embed-metadata --embed-chapters --embed-thumbnail'
alias ff='fastfetch'
alias antigravity='/opt/Antigravity/bin/antigravity-ide'
alias 'edit'='code ~/dotfiles/zsh/.zshrc'
alias 'src'='source ~/.zshrc'
alias 'adbf'='adb forward tcp:6000 localfilesystem:/data/local/debugger-socket'


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

# Toggle Quad9 DNS dynamically on the active network interface
quad9() {
    local conn=$(nmcli -t -f TYPE,NAME connection show --active | grep -v '^loopback:' | cut -d: -f2-)

    if [ -z "$conn" ]; then
        echo "Error: No active network connection found."
        return 1
    fi

    case "$1" in
        enable)
            echo "Enabling Quad9 DNS for: $conn"
            sudo nmcli connection modify "$conn" ipv4.dns "9.9.9.9 149.112.112.112" ipv4.ignore-auto-dns yes
            sudo nmcli connection modify "$conn" ipv6.dns "2620:fe::fe 2620:fe::9" ipv6.ignore-auto-dns yes
            sudo nmcli connection up "$conn"
            ;;
        disable)
            echo "Reverting to default DHCP DNS for: $conn"
            sudo nmcli connection modify "$conn" ipv4.dns "" ipv4.ignore-auto-dns no
            sudo nmcli connection modify "$conn" ipv6.dns "" ipv6.ignore-auto-dns no
            sudo nmcli connection up "$conn"
            ;;
        *)
            echo "Usage: quad9 [enable|disable]"
            return 1
            ;;
    esac
}

# --- Startup Applications ---
# Automatically start Niri inside a D-Bus session on TTY1 (from .bash_profile)
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec dbus-run-session niri --session
fi
