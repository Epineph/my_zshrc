# $HOME/.zsh_profile/zsh_git.zsh

git_gpg_keyid="7215FADE4B53085301ED172F7E0D54A2657F6C48"

git config --global user.name "Epineph"
git config --global user.email "heiniwinther@hotmail.com"
git config --global user.signingkey "$git_gpg_keyid"
git config --global commit.gpgsign true
git config --global color.ui auto
git config --global init.defaultBranch main
