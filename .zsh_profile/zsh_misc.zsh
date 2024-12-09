# $HOME/.zsh_profile/zsh_misc.zsh

sudo ryzenadj --max-performance > /dev/null 2>&1 # enabling max performance

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source /usr/share/nvm/init-nvm.sh

# Check if .oh-my-zsh is installed, install if not
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

alias bathelp='bat --plain --language=help --paging=never'
help() {
    "$@" --help 2>&1 | bathelp
}


