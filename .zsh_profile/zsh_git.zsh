# $HOME/.zsh_profile/zsh_git.zsh

git config --global user.signingkey "$git_gpg_keyid"
git config --global commit.gpgsign true
git config --global color.ui auto
git config --global init.default

source $HOME/.zsh_profile/.zsh_git_personal_details.zsh
