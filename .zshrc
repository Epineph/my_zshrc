# $HOME/.zshrc

# Source all configuration files
for config_file in $HOME/.zsh_profile/*.zsh; do
	source $config_file
done


[ -f "/home/heini/.ghcup/env" ] && . "/home/heini/.ghcup/env" # ghcup-env
