DOT_PATH="$(pwd -P)"/..
ln -sf "$DOT_PATH/.config/nvim" ~/.config/nvim
ln -sf "$DOT_PATH/.config/hypr" ~/.config/hypr
ln -sf "$DOT_PATH/.config/waybar" ~/.config/waybar
ln -sf "$DOT_PATH/.config/wofi" ~/.config/wofi
ln -sf "$DOT_PATH/.zshrc" ~/.zshrc
ln -sf "$DOT_PATH/.tmux.conf" ~/.tmux.conf
echo "> links created"

sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
echo "> yay installed"

sudo pacman -S --noconfirm curl
yay -Sy --needed --noconfirm zsh
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

curl -fsS https://dl.brave.com/install.sh | sh
echo "> brave installed"

sudo pacman -S --noconfirm tmux networkmanager nemo wofi zenity
sudo pacman -S --noconfirm grim slurp wl-copy cliphist brightnessctl pamixer
yay -Sy --needed --noconfirm adwaita-dark hyprpicker-git nerd-fonts unimatrix wofi-emoji
echo "> useful packages installed"
