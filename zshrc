# $HOME/.zshrc

# Source all configuration files
for config_file in $HOME/.zsh_profile/*.zsh; do
	source $config_file
done


[ -f "/home/heini/.ghcup/env" ] && . "/home/heini/.ghcup/env" # ghcup-env

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE='/home/heini/repos/micromamba-releases/~/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/heini/micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
