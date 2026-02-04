# ohmyzsh theme
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="tensor"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Aliases
alias larth='ls -larth'
alias python=python3
alias nv=neovide
alias so=source
alias wl='wl-copy'
alias spt=spotify_player
alias sf=screenfetch

# Scripts
alias initts=~/scripts/initTS.sh
alias lpp=~/scripts/lpp.sh
alias ffimg=~/scripts/ffmpegLoopImg.sh
alias scratch='vim $HOME/shared/notes/scratchpad.md'
alias kbd='sudo ~/scripts/kbd.sh'

# Shell Env Variables
export PATH="$PATH:/home/tensor/.npm-global/bin" # npm global packages
export NVM_DIR="$HOME/.nvm" # nvm
if [ -f "$NVM_DIR/alias/default" ]; then # Always available node (without nvm)
    DEFAULT_NODE_VERSION=$(cat "$NVM_DIR/alias/default")
    export PATH="$NVM_DIR/versions/node/v$DEFAULT_NODE_VERSION/bin:$PATH"
fi
nvm() { # Lazy load full nvm functionality when explicitly called
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}

export PATH=$PATH:/usr/local/go/bin # golang
export PATH=$PATH:/home/tensor/.cargo/bin # cargo
export PATH="/home/tensor/.local/share/solana/install/active_release/bin:$PATH" # Solana CLI
export PATH=$PATH:/home/tensor/go/bin # golang
export PATH=$PATH:/home/tensor/.config/emacs/bin # doom
export PATH="/home/tensor/.local/bin:$PATH" # surfpool maybe
