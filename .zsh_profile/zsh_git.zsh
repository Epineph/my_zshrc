# $HOME/.zsh_profile/zsh_git.zsh
git_gpg_keyid="D3877098769E23F1B7704154F67CCE941A510F9E"
git config --global user.signingkey "$git_gpg_keyid"
git config --global commit.gpgsign true
git config --global color.ui auto
git config --global init.default

#source $HOME/.zsh_profile/.zsh_git_personal_details.zsh
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global merge.conflictStyle zdiff3

