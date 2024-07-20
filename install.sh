#!/bin/bash

# Define variables
REPO_URL="https://github.com/Epineph/my_zshrc.git"
INSTALL_DIR="$HOME/zsh_setup"
ZSHRC_DEST="$HOME/.zshrc"
ZSH_PROFILE_DEST="$HOME/.zsh_profile"
LSCOLORS_URL="https://api.github.com/repos/trapd00r/LS_COLORS/tarball/master"

sudo pacman -S --needed jq lsd

# Determine if LSCOLORS is installed

if [[ ! -f "$HOME/.local/share/lscolors.sh" ]]; then
	mkdir /tmp/LS_COLORS && \
		curl -L "$LSCOLORS_URL" | tar xzf - \
		--directory=/tmp/LS_COLORS --strip=1
	( cd /tmp/LS_COLORS && make install )
fi


# Clone the repository
git clone "$REPO_URL" "$INSTALL_DIR"

# Create the .zsh_profile directory if it doesn't exist
mkdir -p "$ZSH_PROFILE_DEST"

# Copy the .zshrc file
cp "$INSTALL_DIR/.zshrc" "$ZSHRC_DEST"

# Copy all the .zsh_profile files
cp "$INSTALL_DIR/.zsh_profile/*.zsh" "$ZSH_PROFILE_DEST"

# Install zsh if not already installed
if ! command -v zsh &> /dev/null
then
    sudo pacman -S zsh --noconfirm
fi

# Change the default shell to zsh
chsh -s "$(which zsh)"

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install zinit
if [ ! -d "${ZINIT_HOME:-${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git}" ]; then
    mkdir -p "$(dirname "${ZINIT_HOME:-${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git}")"
    git clone https://github.com/zdharma-continuum/zinit.git "${ZINIT_HOME:-${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git}"
fi

# Source the .zshrc to apply changes
source "$ZSHRC_DEST"

echo "Zsh setup completed. Please restart your terminal."

