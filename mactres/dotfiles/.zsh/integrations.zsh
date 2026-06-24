# ====================== Tool Integrations ======================

# iTerm2 Shell Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# fzf (fuzzy finder)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Optional: Better fzf + zsh integration (if you want)
 zinit light Aloxaf/fzf-tab

# ====================== Starship Prompt ======================
eval "$(starship init zsh)"
