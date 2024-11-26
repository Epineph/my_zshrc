# $HOME/.zsh_profile/zsh_git.zsh

git_gpg_keyid="<redacted>"

git config --global user.name "<redacted>"
git config --global user.email "<redacted>"
git config --global user.signingkey "$git_gpg_keyid"
git config --global commit.gpgsign true
git config --global color.ui auto
git config --global init.defaultBranch main
