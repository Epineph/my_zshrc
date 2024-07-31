# $HOME/.zsh_profile/zsh_conda.zsh

# Conda initialization

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/home/heini/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/home/heini/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/home/heini/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/heini/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup

#if [ -f "/home/heini/miniconda3/etc/profile.d/mamba.sh" ]; then
#    . "/home/heini/miniconda3/etc/profile.d/mamba.sh"
#fi
# <<< conda initialize <<<
#

#[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/heini/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/heini/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/heini/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/heini/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/home/heini/miniconda3/etc/profile.d/mamba.sh" ]; then
    . "/home/heini/miniconda3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<
