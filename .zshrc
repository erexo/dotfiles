alias git.b='git checkout -b'
alias git.p='git pull'
alias git.c='git commit -m'
alias git.t='git describe --abbrev=0 --tags'
alias grep.='grep -Rin'
alias find.='find -iname'
alias vim='nvim'
alias v='nvim -c "Telescope find_files"'
alias vim.edit='nvim ~/.config/nvim/init.lua'
alias zsh.edit='nvim ~/.zshrc'

export ZSH_THEME="simple"
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:~/go/bin
source $ZSH/oh-my-zsh.sh

