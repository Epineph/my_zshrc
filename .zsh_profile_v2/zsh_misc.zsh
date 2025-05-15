# $HOME/.zsh_profile/zsh_misc.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source /usr/share/nvm/init-nvm.sh

# Check if .oh-my-zsh is installed, install if not
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

alias bathelp='bat --language=help --paging=never --pager="less" --theme="Monokai Extended Bright" --chop-long-lines --squeeze-blank --tabs 2 --wrap="auto" --binary="as-text" --nonprintable-notation="caret" --italic-text="always" --style="grid,header-filename,snip,snip"'
help() {
    "$@" --help 2>&1 | bathelp
}

source $ZSH/oh-my-zsh.sh

plugins=( 
    git
    archlinux
    virtualenvwrapper
    fzf
    pylint
    git-prompt
    glassfish
    gnu-utils
    git-extras
    github
    npm
    nvm
    tmux
    zsh-interactive-cd
    zsh-navigation-tools
    systemd
    toolbox
    tmuxinator
    python
#    autoenv
    autopep8
#    starship
    systemadmin
    ssh
    textastic
    textmate
    dotenv
    rake
    bundler
    systemd
    coffee
)

#source /etc/profile.d/cuda.sh
