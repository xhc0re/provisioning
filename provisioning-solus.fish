#!/usr/bin/fish

omf install dangerous

curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

fisher install reitzig/sdkman-for-fish@v1.4.0

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

fish_add_path ~/.cargo/bin/

curl https://nim-lang.org/choosenim/init.sh -sSf | sh
