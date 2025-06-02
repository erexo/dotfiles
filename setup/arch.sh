DOT_PATH="$(pwd -P)"/..
ln -sf "$DOT_PATH/.config/nvim" ~/.config/nvim
ln -sf "$DOT_PATH/.config/hypr" ~/.config/hypr
ln -sf "$DOT_PATH/.config/waybar" ~/.config/waybar
ln -sf "$DOT_PATH/.config/wofi" ~/.config/wofi
ln -sf "$DOT_PATH/.zshrc" ~/.zshrc
ln -sf "$DOT_PATH/.tmux.conf" ~/.tmux.conf
echo "> links created"

echo "timeout 0" | sudo tee -a /boot/loader/loader.conf
echo "> bootloader timeout removed"

sudo pacman -S --noconfirm curl wget
GO_VER=$(curl -s 'https://go.dev/VERSION?m=text' | head -n 1)
mkdir -p ~/go/src
rm -rf ~/go/go
wget -qO- https://go.dev/dl/$GO_VER.linux-amd64.tar.gz | tar -xz -C ~/go
echo "> $GO_VER installed"

sudo pacman -S --needed --noconfirm git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
rm -rf yay
echo "> yay installed"

sudo pacman -S --noconfirm kitty
echo "> kitty installed"

yay -Sy --needed --noconfirm zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
echo "> zsh installed"

go install github.com/go-delve/delve/cmd/dlv@latest
sudo pacman -S --noconfirm neovim xclip ripgrep zip unzip lazygit
echo "> nvim installed"

sudo pacman -S --noconfirm hyprland hyprpicker
echo "> hyprland installed"

sudo pacman -S --noconfirm ly
sudo systemctl enable ly
echo "animation = matrix" | sudo tee -a /etc/ly/config.ini
echo "kernel.printk = 3 3 3 3" | sudo tee /etc/sysctl.d/99-silence-kernel.conf
echo "> ly installed"

sudo pacman -S --noconfirm pipewire wireplumber xdg-desktop-portal-hyprland
sudo pacman -S --noconfirm tmux networkmanager wofi zenity hyprpaper waybar
sudo pacman -S --noconfirm thunar tumbler thunar-archive-plugin file-roller
sudo pacman -S --noconfirm grim slurp wl-clipboard cliphist brightnessctl pamixer
sudo pacman -S --noconfirm ttf-font-awesome noto-fonts-emoji
sudo pacman -S --noconfirm fastfetch btop
yay -Sy --needed --noconfirm adwaita-dark nerd-fonts unimatrix wofi-emoji
echo "> useful packages installed"

sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
echo "> enabled network manager"

yay -Sy --needed --noconfirm brave-bin
echo "> brave installed"

echo "reboot now"
