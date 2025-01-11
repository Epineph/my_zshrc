# $HOME/.zsh_profile/zsh_git.zsh

git_gpg_keyid="0639286F2F41CEF98DDACE14D79B97BF040BC113"

git config --global user.name "epineph"
git config --global user.email "heiniwinther@hotmail.com"
git config --global user.signingkey "$git_gpg_keyid"
git config --global commit.gpgsign true
git config --global color.ui auto
git config --global init.defaultBranch main


