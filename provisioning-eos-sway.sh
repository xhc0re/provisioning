#!/bin/bash

echo 'installing dependencies, utilities and apps'
yay

yay -R --noconfirm swaylock
yay -R --noconfirm sway
yay -R --noconfirm swaybg
yay -R --noconfirm wlroots

yay -Sy --noconfirm --answerdiff None --answerclean None --removemake --needed \
signal-desktop telegram-desktop swaylock-fancy-git swaylock-effects-git \
dmenu waybar wofi grim slurp mako kitty neovim code usbutils coreutils \
ripgrep exa bat tree fd starship zsh pfetch zathura lxappearance \
papirus-icon-theme brightnessctl rustup httpie curlie nodejs zathura-pdf-mupdf \
sway-borders-git

echo 'configuring rust'

rustup default stable

echo 'installing rust-analyzer'

if [[ ! -d ~/.local/bin ]]; then
    mkdir -p ~/.local/bin
fi

URL=$(http --headers https://github.com/rust-lang/rust-analyzer/releases/latest | grep Location | awk -F ' ' '{print $2}')
FIXED_URL=$(echo $URL | sed 's/\r//' | sed 's/tag/download/g')
curl -L -o rust-analyzer-x86_64-unknown-linux-gnu.gz "${FIXED_URL}/rust-analyzer-x86_64-unknown-linux-gnu.gz"
gzip -d rust-analyzer-x86_64-unknown-linux-gnu.gz
mv -f rust-analyzer-x86_64-unknown-linux-gnu ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer

echo 'configuring neovim'

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if [[ ! -d ~/.config/nvim ]]; then
    git clone https://github.com/xhc0re/nvim ~/.config/nvim
fi

echo 'cloning demus07/sway-dots'

git clone https://github.com/demus07/sway-dots

echo 'configuring zathura'

if [[ ! -d ~/.config/zathura ]]; then
    mkdir -p ~/.config/zathura
fi

cp ./sway-dots/zathura/* ~/.config/zathura/

echo 'configuring kitty'

if [[ ! -d ~/.config/kitty ]]; then
    mkdir -p ~/.config/kitty
fi

cp ./sway-dots/kitty/* ~/.config/kitty/

echo 'configuring wofi'

if [[ ! -d ~/.config/wofi ]]; then
    mkdir -p ~/.config/wofi
fi

cp ./sway-dots/wofi/* ~/.config/wofi/

echo 'configuring mako'
      
if [[ ! -d ~/.config/mako ]]; then
    mkdir -p ~/.config/mako
fi
    
cp ./sway-dots/mako/* ~/.config/mako/

echo 'configuring waybar'

rm -fr ~/.config/waybar/*

cp -r ./sway-dots/waybar/* ~/.config/waybar/

echo 'configuring sway'

rm -fr ~/.config/sway/*

cp -r ./sway-dots/sway/* ~/.config/sway/

echo 'configuring zsh'

cat zshrc > ~/.zshrc
cat zshenv > ~/.zshenv

if [[ ! -d ~/.oh-my-zsh ]]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if [[ ! -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

echo 'configuring starship'

if [[ ! -f ~/.config/starship.toml ]]; then
    cp ./sway-dots/starship.toml ~/.config/
fi

echo 'setting wallpaper'

cp ./purple.jpg ~/Obrazy/wallpapers/

sed -i 's/\/home\/demus\/Wallpaper\/004.png/\/home\/c0re\/Obrazy\/wallpapers\/purple.jpg/g' ~/.config/sway/config 

echo 'configuring git'

git config --global user.name "hc0re"
git config --global user.email "hc0re@tuta.io"

echo 'installing sdkman and sdks'

if [[ ! -f ~/.sdkman/bin/sdkman-init.sh ]]; then
    curl -s "https://get.sdkman.io" | bash
fi

source "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java 17.0.3-zulu
sdk install gradle
sdk install gradleprofiler
sdk install micronaut
sdk install kotlin
sdk install springboot
sdk install taxi
sdk install vertx

echo 'cleaning up'

rm -fr sway-dots
chsh -s /usr/bin/zsh
#reboot

