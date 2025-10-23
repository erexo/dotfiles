alias git.b='git checkout -b'
alias git.p='git pull'
alias git.c='git commit -m'
alias git.t='git describe --abbrev=0 --tags'
alias grep.='grep -Rin'
alias find.='find -iname'
alias vim='nvim'
alias v='nvim -c "Telescope find_files"'
alias vim.edit='nvim --cmd ":cd ~/.config/nvim/" -c ":e init.lua"'
alias zsh.edit='nvim --cmd ":cd ~/" ~/.zshrc'
alias tmux.edit='nvim --cmd ":cd ~/" ~/.tmux.conf'

alias c='xclip -selection clipboard'

alias cd.dot='cd ~/dotfiles'

DISABLE_AUTO_UPDATE="true"

export ZSH_THEME="simple"
export ZSH="$HOME/.oh-my-zsh"
export PATH=$PATH:~/go/bin
export PATH=$PATH:~/go/go/bin
export PATH=$PATH:/opt/nvim-linux-x86_64/bin
export PATH=$PATH:~/dotnet
export DOTNET_ROOT=~/dotnet
source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'
export TERM='xterm-256color'

if [ -z "$TMUX" ] && command -v tmux >/dev/null 2>&1; then
  tmux attach-session -t main || tmux new-session -s main
fi

ZSHRC_DIR="$HOME/dotfiles"
[[ -f "$ZSHRC_DIR/.extrarc" ]] && source "$ZSHRC_DIR/.extrarc"
