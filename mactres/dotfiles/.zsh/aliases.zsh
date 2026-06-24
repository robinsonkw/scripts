# ====================== Aliases ======================

# Zsh config
alias zshconfig="nvim ~/.zshrc"
alias zshreload="source ~/.zshrc"
alias rebash="source ~/.zshrc"

# Zinit
alias zinitlist="zinit list"
alias zinitstatus="zinit status"
alias zinitupdate="zinit update"

# Editor
alias vim="nvim"
alias vi="nvim"
alias v="nvim"

# Directory shortcuts
alias scripts="cd ~/Documents/scripts"
alias notes="cd ~/Documents/notes"

# Listing
alias ls="ls -la --color=auto"
alias ll="ls -lh --color=auto"

# Network
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
alias ping="ping -c 4"
alias up='ping -c 200'

# Speedtest
alias speedtest="~/Documents/scripts/speedtest.sh"
alias view-speed="cat ~/speedtest.file | tail -10"

# SSH
alias ssh-cisco="sshpass -f ~/.ssh/.cisco ssh cisco"

# Git shortcuts (you already get many from the OMZP::git plugin)
# You can add more here if you want
alias gpush="git push"
alias gpull="git pull"
alias gstat="git status"
alias gadd="git add ."

# Miscellaneous
alias weather="curl wttr.in"
alias c="clear"

# Reload services if needed
# alias dnsflush="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
