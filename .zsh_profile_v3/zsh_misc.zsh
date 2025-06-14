# $HOME/.zsh_profile/zsh_misc.zsh

#if ! command -v ryzenadj &> /dev/null; then
#  echo "ryzenadj not found! Please install it"
#else
#  sudo ryzenadj --max-performance 
#fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source /usr/share/nvm/init-nvm.sh

# Check if .oh-my-zsh is installed, install if not
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL \
      https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

source /etc/profile.d/java.sh

# 1) Define a ZLE widget that calls fzf-script-picker and splices its output
fzf_insert_script() {
  local cmd
  cmd=$(fzf-script-picker) || return 1
  LBUFFER+="$cmd "            # append to the left side of the prompt
  zle reset-prompt
}
zle -N fzf_insert_script

# 2) Bind it to a key, e.g. Ctrl-P
bindkey '^P' fzf_insert_script


#alias bathelp='bat --language=help --paging=never --pager="less" \
#--theme "gruvbox-dark" --chop-long-lines --squeeze-blank --tabs 2 \
#--wrap="auto" --binary="as-text" --nonprintable-notation="caret" \
#--italic-text="always" --style="grid,header-filename,snip,snip"'
#help() {
#    "$@" --help 2>&1 | bathelp
#}

#source /etc/profile.d/cuda.sh
