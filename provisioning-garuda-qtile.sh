#!/bin/bash

echo 'installing dependencies, utilities and apps'
yay

yay -Sy --noconfirm --answerdiff None --answerclean None --removemake --needed \
signal-desktop telegram-desktop neovim code usbutils coreutils \
ripgrep exa bat tree fd zathura rustup httpie curlie nodejs \
zathura-pdf-mupdf ncmatrix go nim

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

# reboot

