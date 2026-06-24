# ====================== Environment Variables ======================

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Editor
export EDITOR="nvim"
export VISUAL="$EDITOR"

# ====================== PATH & Tools ======================

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# pipx
export PATH="$PATH:$HOME/.local/bin"

# Add other paths if needed
# export PATH="$PATH:/usr/local/sbin"

# ====================== Other Settings ======================

# History settings (better than defaults)
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Prevent accidental rm * issues (optional but recommended)
setopt RM_STAR_WAIT
