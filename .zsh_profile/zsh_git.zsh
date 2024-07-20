# $HOME/.zsh_profile/zsh_git.zsh

git_gpg_keyid="6F57C7343E565225007CBA29BB40E812A1BF504E"

git config --global user.name "Heini Winther Johnsen"
git config --global user.email "heiniwinther@hotmail.com"
git config --global user.signingkey "$git_gpg_keyid"
git config --global commit.gpgsign true
git config --global color.ui auto
git config --global init.defaultBranch main
