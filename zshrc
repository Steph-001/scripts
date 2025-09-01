#!/bin/zsh
# ================================================================
# ZSH Configuration
# ================================================================

# --------------------------------
# Environment Variables
# --------------------------------
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# API Keys (consider moving to a separate private file)
[ -f ~/.private_env ] && source ~/.private_env
# Directory paths
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"

# --------------------------------
# PATH Configuration
# --------------------------------
# Homebrew
export PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/opt/imagemagick/bin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/opt/clang-format/bin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/opt/clangd/bin:$PATH"

# Local and system paths
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
export PATH="/usr/games:/usr/local/games:$PATH"
export PATH="/snap/bin:$PATH"

# Node.js
export PATH="$HOME/.nvm/versions/node/v18.20.7/bin:$PATH"

# WSL Windows integration
export PATH="/usr/lib/wsl/lib:$PATH"
export PATH="/mnt/c/Users/steph/cmder/vendor/conemu-maximus5/ConEmu/Scripts:$PATH"
export PATH="/mnt/c/Users/steph/cmder/vendor/conemu-maximus5/ConEmu:$PATH"
export PATH="/mnt/c/Program Files/ImageMagick-7.1.1-Q16-HDRI:$PATH"
export PATH="/mnt/c/Users/steph/AppData/Local/Programs/Python/Python313:$PATH"
export PATH="/mnt/c/WINDOWS/system32:$PATH"
export PATH="/mnt/c/WINDOWS:$PATH"
export PATH="/mnt/c/WINDOWS/System32/Wbem:$PATH"
export PATH="/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0:$PATH"
export PATH="/mnt/c/WINDOWS/System32/OpenSSH:$PATH"
export PATH="/mnt/c/ProgramData/chocolatey/bin:$PATH"
export PATH="/mnt/c/yt-dlp:$PATH"
export PATH="/mnt/c/Program Files/dotnet:$PATH"
export PATH="/mnt/c/Program Files/Go/bin:$PATH"
export PATH="/mnt/c/Program Files/Git/cmd:$PATH"
export PATH="/mnt/c/Program Files/Git/bin:$PATH"
export PATH="/mnt/c/Users/steph/AppData/Local/Programs/Microsoft VS Code/bin:$PATH"

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

# Load custom dircolors everywhere
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
        # Force colors on Windows paths where permissions don't trigger them
        command ls --color=always "$@"
    else
        command ls --color=auto "$@"
    fi
}



# --------------------------------
# Aliases
# --------------------------------
# Navigation shortcuts
alias lyc="cd /mnt/c/Users/steph/OneDrive\ -\ Région\ Île-de-France"
alias nts="cd /mnt/c/Users/steph/OneDrive\ -\ Région\ Île-de-France/nts"
alias notes="cd /home/steph/notes"
alias pc="cd /mnt/c/Users/steph"

# File operations - using smart_ls function
alias l="smart_ls -lt"
alias ll="smart_ls -al"
alias li="smart_ls -1d .[^.]* .??* 2>/dev/null | sort -u"
alias ls="smart_ls"
alias open="explorer.exe"
alias tag="filetags"
alias fd="fdfind"
alias bat="batcat"

# Development
alias nn="nvim"
#alias python="/home/linuxbrew/.linuxbrew/bin/python3"
#alias pip="/usr/bin/python3 -m pip"
alias hugodev="hugo server --disableFastRender --watch --poll 1000ms"
alias aider='aider --model claude-3-5-sonnet-20241022'

# File opening shortcuts
alias simple='cmd.exe /c start "" "$(wslpath -w /mnt/c/Users/Steph/Documents/Chess/Livres/strategy/simple_chess.epub)"'

# Cloud sync aliases
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
alias S9='cd "/mnt/c/Users/steph/OneDrive - Région Île-de-France/Charly/Classes/S9" && ls -l'
alias P9='cd "/mnt/c/Users/steph/OneDrive - Région Île-de-France/Charly/Classes/P9" && ls -l'
# --------------------------------
# External Tool Configurations
# --------------------------------
# Load external tools
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Homebrew environment
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
  # Use fd to generate the file list, skip .git, include hidden files
  local file
  file=$(fd --type f --hidden --exclude .git \
    | fzf --height 40% --reverse --nth=-1 --tiebreak=length)

  if [ -n "$file" ]; then
    # Get absolute path
    file=$(realpath "$file")
    # Convert WSL path to Windows path
    winpath=$(wslpath -w "$file")
    # Open with default Windows program
    cmd.exe /c start "" "$winpath"
  fi
}


alias openw='open-with-windows'


# csv list to markdown table
mdtable() {
    if [ $# -lt 2 ]; then
        echo "Usage: mdtable <file.csv> <title> [extra_columns...]"
        return 1
    fi

    local csv="$1"
    local title="$2"
    shift 2
    local extras=("$@")
    # Replace spaces/underscores with dashes for filename
    local filename="${title// /_}.md"
    filename="${filename//_/-}"

    local first_creation=false

    # If file doesn't exist, create it with frontmatter
    if [ ! -f "$filename" ]; then
        local date=$(date +%Y-%m-%d)
        {
            echo "---"
            echo "title: \"${title//_/ }\""
            echo "date: $date"
            echo "tags: []"
            echo "---"
            echo
            echo "# ${title//_/ }"
            echo
        } > "$filename"
        first_creation=true
    fi

    # Append the table
    csv_to_md.py "$csv" "${extras[@]}" >> "$filename"

    # Open in nvim:
    if $first_creation; then
        # Jump to tags, move inside [], enter insert mode
        nvim +"/tags: \[\]" +"normal f[a" "$filename"
    else
        nvim "$filename"
    fi
        # Open in nvim:
    if $first_creation; then
        nvim +"call search('tags: \\[\\]')" \
             +"normal f[" \
             +"call feedkeys('i', 'n')" \
             "$filename"
    else
        nvim "$filename"
    fi

}


# --------------------------------
# Final Initialization
# --------------------------------
# Any final setup commands go here
