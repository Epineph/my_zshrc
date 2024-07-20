# $HOME/.zshrc

# Source all configuration files
for config_file in $HOME/.zsh_profile/*.zsh; do
	source $config_file
done
