# ====================== Main Zsh Configuration ======================

# Load Zinit + all plugins first
source ~/.zsh/zinit.zsh

# Load modular configuration files
for file in ~/.zsh/*.zsh; do
  [[ "$file" != *"/zinit.zsh" ]] && source "$file"
done

echo "🚀 Zsh config loaded successfully"
