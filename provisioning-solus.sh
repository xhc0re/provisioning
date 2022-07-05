#!/bin/bash 

sudo eopkg update-repo -f
sudo eopkg up -d
sudo eopkg upgrade

sudo eopkg install -y vscode telegram signal-desktop httpie neovim wireguard-tools github-cli font-jetbrainsmono-ttf gnome-tweaks \
	fish dconf-editor nvidia-glx-driver

echo 'installing rust-analyzer'

if [[ ! -d ~/.local/bin ]]; then
    mkdir -p ~/.local/bin
fi

#URL=$(http --headers https://github.com/rust-lang/rust-analyzer/releases/latest | grep Location | awk -F ' ' '{print $2}')
#FIXED_URL=$(echo $URL | sed 's/\r//' | sed 's/tag/download/g')
#curl -L -o rust-analyzer-x86_64-unknown-linux-gnu.gz "${FIXED_URL}/rust-analyzer-x86_64-unknown-linux-gnu.gz"
#gzip -d rust-analyzer-x86_64-unknown-linux-gnu.gz
#mv -f rust-analyzer-x86_64-unknown-linux-gnu ~/.local/bin/rust-analyzer
#chmod +x ~/.local/bin/rust-analyzer

#echo 'configuring neovim'

#sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
#       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

#if [[ ! -d ~/.config/nvim ]]; then
#    git clone https://github.com/xhc0re/nvim ~/.config/nvim
#fi

git config --global user.name "hc0re"
git config --global user.email "hc0re@tuta.io"

chsh -s /usr/bin/fish
