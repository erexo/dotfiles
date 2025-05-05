DOT_PATH="$(pwd -P)"/..
mkdir -p ~/.config
ln -sf "$DOT_PATH/.config/nvim" ~/.config/nvim
ln -sf "$DOT_PATH/.zshrc" ~/.zshrc
echo "> links created"

sudo apt install -y build-essential zsh curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
echo "> zsh installed"

GO_VER=$(curl -s 'https://go.dev/VERSION?m=text' | head -n 1)
mkdir -p ~/go/src
rm -rf ~/go/go
wget -qO- https://go.dev/dl/$GO_VER.linux-amd64.tar.gz | tar -xz -C ~/go
echo "> $GO_VER installed"

LAZYGIT_VER=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VER}/lazygit_${LAZYGIT_VER}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
echo "> Lazygit $LAZYGIT_VER installed"

~/go/go/bin/go install github.com/go-delve/delve/cmd/dlv@latest
sudo apt install -y xclip ripgrep fd-find unzip
curl -LO https://github.com/neovim/neovim/releases/download/v0.11.0/nvim-linux-x86_64.tar.gz
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
echo "> nvim installed"
