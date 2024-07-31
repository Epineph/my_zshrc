# $HOME/.zsh_profile/zsh_git.zsh

git_gpg_keyid="C582D413C389CFEB7ED7E712C10A9019600780FC"

git config --global user.name "Heini Winther Johnsen"
git config --global user.email "heiniwinther@hotmail.com"
git config --global user.signingkey "$git_gpg_keyid"
git config --global commit.gpgsign true
git config --global color.ui auto
git config --global init.defaultBranch main
