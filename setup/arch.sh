DOT_PATH="$(pwd -P)"/..
ln -sf "$DOT_PATH/.config/nvim" ~/.config/nvim
ln -sf "$DOT_PATH/.config/hypr" ~/.config/hypr
ln -sf "$DOT_PATH/.config/waybar" ~/.config/waybar
ln -sf "$DOT_PATH/.config/wofi" ~/.config/wofi
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
sudo pacman -S --noconfirm neovim xclip ripgrep zip unzip
echo "> nvim installed"

sudo pacman -S --noconfirm networkmanager nemo wofi zenity
sudo pacman -S --noconfirm grim slurp wl-copy cliphist brightnessctl pamixer
yay -S adwaita-dark
yay -S hyprpicker-git
yay -S nerd-fonts
yay -S unimatrix
yay -S wofi-emoji
echo "> useful packages installed"
