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

DISABLE_AUTO_UPDATE="true"

export ZSH_THEME="simple"
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:~/go/bin
export PATH=$PATH:/usr/local/nvim-linux64/bin
export PATH=$PATH:~/dotnet
export DOTNET_ROOT=~/dotnet
source $ZSH/oh-my-zsh.sh

EDITOR=nvim

