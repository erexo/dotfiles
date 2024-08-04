mkdir -p ~/.config/nvim/ && ln -sf "$(pwd -P)"/init.lua ~/.config/nvim/
ln -sf "$(pwd -P)"/.zshrc ~/.zshrc
echo "> links created"

sudo apt install -y zsh curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
echo "> zsh installed"

GO_VER=$(curl -s 'https://go.dev/VERSION?m=text' | head -n 1)
mkdir -p ~/go/src
rm -rf ~/go/go
wget -qO- https://go.dev/dl/$GO_VER.linux-amd64.tar.gz | tar -xz -C ~/go
echo "> $GO_VER installed"

go install github.com/go-delve/delve/cmd/dlv@latest
apt install -y xclip ripgrep fd-find unzip
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
echo "> nvim installed"
