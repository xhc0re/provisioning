#!/bin/bash

echo "installing basic utilities and requirements:"

CONFIG_DIR=~/.config

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install -y curl git exuberant-ctags software-properties-common gnupg \
			kitty apt-transport-https zsh rust-all rust-src httpie htop \
			cmatrix golang

echo "configuring zsh"

if [[ ! -f ~/.zshenv ]]; then
    cp zshenv ~/.zshenv
fi

if [[ ! $SHELL  == "/usr/bin/zsh" ]]; then                                                                                                
  echo "changing default shell"
  chsh -s /usr/bin/zsh
fi   

echo "setting up kitty as default terminal"

gsettings set org.gnome.desktop.default-applications.terminal exec kitty
gsettings set org.gnome.shell.extensions.pop-shell tile-by-default true

echo "cloning tokyonight theme"
git clone https://github.com/folke/tokyonight.nvim.git

echo "checking kitty configs"

if [[ ! -d $CONFIG_DIR/kitty ]]; then
    echo "kitty config folder does not exist, creating"
    mkdir $CONFIG_DIR/kitty
fi

if [[ ! -f $CONFIG_DIR/kitty/kitty.conf ]]; then
    echo "kitty config does not exist, copying"
    cp tokyonight.nvim/extras/kitty_tokyonight_night.conf $CONFIG_DIR/kitty/kitty.conf
fi

echo "checking Xresources dotfile"

if [[ ! -f ~/.Xresources ]]; then
    echo "copying Xresources config"
    cp tokyonight.nvim/extras/xresources_tokyonight_night.Xresources ~/.Xresources
fi

echo "configuring pop shell"

gsettings set org.gnome.shell.extensions.pop-shell show-title false

echo "installing vscodium"

if [[ ! -f /etc/apt/sources.list.d/vscodium.list ]]; then
    wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/etc/apt/trusted.gpg.d/vscodium.gpg
    echo 'deb https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list.d/vscodium.list
fi

sudo apt-get update
sudo apt-get install -y codium

echo "installing and configuring neovim"

echo "installing rust-analyzer"

if [[ ! -d ~/.local/bin ]]; then
    mkdir -p ~/.local/bin
fi

URL=$(http --headers https://github.com/rust-lang/rust-analyzer/releases/latest | grep Location | awk -F ' ' '{print $2}')        
FIXED_URL=$(echo $URL | sed 's/\r//' | sed 's/tag/download/g')
curl -L -o rust-analyzer-x86_64-unknown-linux-gnu.gz "${FIXED_URL}/rust-analyzer-x86_64-unknown-linux-gnu.gz"
gzip -d rust-analyzer-x86_64-unknown-linux-gnu.gz                                                                                 
mv -f rust-analyzer-x86_64-unknown-linux-gnu ~/.local/bin/rust-analyzer                                                              
chmod +x ~/.local/bin/rust-analyzer                                                                                               

sudo curl -sL https://deb.nodesource.com/setup_14.x | bash -
sudo apt-get install -y nodejs vim

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get install -y neovim

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if [[ ! -d ~/.config/nvim ]]; then
    git clone https://github.com/xhc0re/nvim ~/.config/nvim
fi



if [[ ! -d ~/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

cp c0re.zsh-theme ~/.oh-my-zsh/themes/
cat zshrc > ~/.zshrc

if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

echo "installing signal"

# 1. Install our official public software signing key
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg

if [[ ! -f /etc/apt/sources.list.d/signal-xenial.list ]]; then
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
      sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
fi

if [[ ! -f ~/.sdkman/bin/sdkman-init.sh ]]; then
    curl -s "https://get.sdkman.io" | bash
fi

sudo apt-get update
sudo apt-get install signal-desktop

source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java 17.0.3-zulu
sdk install gradle
sdk install gradleprofiler
sdk install micronaut
sdk install kotlin
sdk install springboot
sdk install taxi
sdk install vertx

go install github.com/rs/curlie@latest

echo "cleaning up"

rm -fr tokyonight.nvim
rm signal-desktop-keyring.gpg

reboot
