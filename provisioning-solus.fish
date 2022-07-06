#!/usr/bin/fish

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

omf install dangerous

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

fisher install reitzig/sdkman-for-fish@v1.4.0

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

fish_add_path ~/.cargo/bin/

curl https://nim-lang.org/choosenim/init.sh -sSf | sh

set -ga fish_user_paths ~/.nimble/bin