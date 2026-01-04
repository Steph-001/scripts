#!/bin/zsh
# ================================================================
# ZSH Configuration
# ================================================================

# --------------------------------
# Environment Variables
# --------------------------------
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# API Keys
[ -f ~/.private_env ] && source ~/.private_env

# Directory paths
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"

# --------------------------------
# PATH Configuration
# --------------------------------
# Don't rebuild PATH - let WSL handle base system and Windows paths
# Just prepend our custom directories

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# Homebrew
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/sbin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/opt/imagemagick/bin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/opt/clang-format/bin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/opt/clangd/bin:$PATH"

# Scripts
export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/chess_scripts:$PATH"
export PATH="$HOME/Sync/scripts:$PATH"

# System paths
export PATH="/snap/bin:$PATH"
export PATH="/usr/games:/usr/local/games:$PATH"

# Node.js
export PATH="$HOME/.nvm/versions/node/v18.20.7/bin:$PATH"

# WSL Windows integration
export PATH="/mnt/c/Users/steph/AppData/Local/Microsoft/WindowsApps:$PATH"
export PATH="/mnt/c/Users/steph/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"

# FZF configuration
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --exclude .git'

# --------------------------------
# Oh My Zsh Configuration
# --------------------------------
ZSH_THEME="agnoster"
plugins=(git)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'

source $ZSH/oh-my-zsh.sh

# --------------------------------
# Clean WSL Color Configuration
# --------------------------------

# Load custom dircolors
if [ -f ~/.dircolors ]; then
    eval $(dircolors ~/.dircolors)
fi

# Function to detect Windows filesystem paths
is_windows_path() {
    case "$PWD" in
        /mnt/c/*|/mnt/d/*|/mnt/e/*|/mnt/f/*) return 0 ;;
        *) return 1 ;;
    esac
}

# Smart ls function that forces colors on Windows paths
smart_ls() {
    if is_windows_path; then
        command ls --color=always "$@"
    else
        command ls --color=auto "$@"
    fi
}

# --------------------------------
# Aliases
# --------------------------------
# Navigation shortcuts
alias lyc='cd "/mnt/c/Users/steph/OneDrive - Région Île-de-France/Charly/Classes" && ls -l'
alias nts='cd "/mnt/c/Users/steph/OneDrive - Région Île-de-France/Charly/classes/nts" && ls -l'
alias notes='cd "$HOME/notes" && ls -l'
alias pc='cd /mnt/c/Users/steph'
alias desk='cd /mnt/c/Users/steph/desktop'
alias student-comments='python3 "$HOME/scripts/csv_to_comments.py"'

# File operations
alias l="smart_ls -lt"
alias ll="smart_ls -al"
alias li="smart_ls -1d .[^.]* .??* 2>/dev/null | sort -u"
alias ls="smart_ls"
alias open="explorer.exe"
alias fd="fdfind"
alias bat="batcat"
alias poub="$HOME/.local/bin/poubelle.sh"

# Development
alias nn="nvim"
alias hugodev="hugo server --disableFastRender --watch --poll 1000ms"
alias aider='aider --model claude-3-5-sonnet-20241022'

# Cloud sync
alias update_prem='rclone sync ~/Sync/premieres/public/ ovh:premieres/ --progress --size-only'
alias update_sec='rclone sync ~/Sync/secondes/public/ ovh:secondes/ --progress --size-only'
alias update_term='rclone sync ~/Sync/terminales/public/ ovh:terminales/ --progress --size-only'
alias update_test='rclone sync ~/webdev/EnglishClass/public/ ovh:test/ --progress --size-only'
alias update_stmg='rclone sync ~/Sync/stmg/public/ ovh:stmg/ --progress --size-only'

# Classes Charly
alias T12='cd "/mnt/c/Users/steph/OneDrive - Région Île-de-France/Charly/Classes/T12_T13" && ls -l'
alias T9='cd "/mnt/c/Users/steph/OneDrive - Région Île-de-France/Charly/Classes/T9" && ls -l'
alias S5='cd "/mnt/c/Users/steph/OneDrive - Région Île-de-France/Charly/Classes/S5" && ls -l'
alias T10='cd "/mnt/c/Users/steph/OneDrive - Région Île-de-France/Charly/Classes/T10_T11" && ls -l'
alias P3='cd "/mnt/c/Users/steph/OneDrive - Région Île-de-France/Charly/Classes/P3" && ls -l'
alias S2='cd "/mnt/c/Users/steph/OneDrive - Région Île-de-France/Charly/Classes/S2_S9" && ls -l'
alias P9='cd "/mnt/c/Users/steph/OneDrive - Région Île-de-France/Charly/Classes/P9" && ls -l'
alias mt='csv_to_md.py'
alias p9w='p9_workspace'
alias t9w='t9_workspace'
alias p3w='p3_workspace'
alias t10w='t10_workspace'
alias t12w='t12_workspace'
alias s2w='s2_workspace'
alias s5w='s5_workspace'

# Mount/unmount Mac Seagate drive
alias mount-mac='sudo mount -t cifs //192.168.1.145/Seagate /mnt/seagate -o username=Stephane,vers=3.0'
alias umount-mac='sudo umount /mnt/seagate'

# --------------------------------
# External Tool Configurations
# --------------------------------
# NVM
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Zsh plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --------------------------------
# Custom Functions
# --------------------------------
# Open file with Neovim using fzf
fo() {
    local file
    file=$(fzf --preview 'batcat --style=numbers --color=always --line-range=:500 {}') && nvim "$file"
}

# Open file with Windows default program
open-with-windows() {
    local file
    file=$(fdfind --type f --hidden --exclude .git | fzf --height 40% --reverse --tiebreak=length)
    
    if [ -n "$file" ]; then
        file=$(realpath "$file")
        winpath=$(wslpath -w "$file")
        cmd.exe /c start "" "$winpath"
    fi
}

alias openw='open-with-windows'

