# $HOME/.zsh_profile/zsh_git.zsh

git_gpg_keyid="<redacted>"

git config --global user.name "<your_username>"
git config --global user.email "<your_email>"
git config --global user.signingkey "$git_gpg_keyid"
git config --global commit.gpgsign true
git config --global color.ui auto
git config --global init.defaultBranch main


git config --global url."https://aur.archlinux.org/".insteadOf "ssh://aur.archlinux.org/"

git config --global url."git@github.com:".insteadOf "https://github.com/"
