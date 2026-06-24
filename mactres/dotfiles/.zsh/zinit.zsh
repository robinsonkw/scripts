# ====================== Zinit Core Setup ======================

# Zinit directory
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Auto-install Zinit if missing
if [[ ! -d $ZINIT_HOME ]]; then
  echo "Installing Zinit..."
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source Zinit
source "${ZINIT_HOME}/zinit.zsh"

# ====================== Plugins ======================

# Core plugins - fast and essential
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions

# Fast syntax highlighting (alternative/better than default)
# zinit light zdharma-continuum/fast-syntax-highlighting

# Git plugin from Oh My Zsh (gives you gst, gco, gaa, etc.)
zinit snippet OMZP::git

# GitHub CLI (gh) - installs latest version + completions
zinit ice from"gh-r" as"program" sbin"**/gh" atload'eval "$(gh completion -s zsh)"'
zinit light cli/cli

# Optional but very useful plugins:
# zinit light zsh-users/zsh-history-substring-search
# zinit light Aloxaf/fzf-tab   # better fzf integration

# ====================== Zinit Settings ======================

# Enable completions
autoload -Uz compinit && compinit

# Zinit options
zinit cdreplay -q   # Replay any compdefs

echo "✅ Zinit loaded successfully with $(zinit list | wc -l) plugins"
