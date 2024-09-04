DOT_PATH="$(pwd -P)"/..
ln -sf "$DOT_PATH/.config/nvim" ~/.config/nvim
ln -sf "$DOT_PATH/.zshrc" ~/.zshrc
echo "> links created"

sudo pacman -S --noconfirm curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
echo "> zsh installed"

GO_VER=$(curl -s 'https://go.dev/VERSION?m=text' | head -n 1)
mkdir -p ~/go/src
rm -rf ~/go/go
wget -qO- https://go.dev/dl/$GO_VER.linux-amd64.tar.gz | tar -xz -C ~/go
echo "> $GO_VER installed"

go install github.com/go-delve/delve/cmd/dlv@latest
sudo pacman -S --noconfirm neovim xclip ripgrep unzip
echo "> nvim installed"
