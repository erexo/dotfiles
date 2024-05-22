mkdir -p ~/.config/nvim/ && ln -sf "$(pwd -P)"/init.lua ~/.config/nvim/
ln -sf "$(pwd -P)"/.zshrc ~/.zshrc
echo "links created"

GO_VER=$(curl -s 'https://go.dev/VERSION?m=text' | head -n 1)
mkdir -p ~/go/src
rm -rf ~/go/go
wget -qO- https://go.dev/dl/$GO_VER.linux-amd64.tar.gz | tar -xz -C ~/go
echo "$GO_VER installed"
