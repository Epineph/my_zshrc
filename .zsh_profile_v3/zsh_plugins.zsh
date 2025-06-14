# $HOME/.zsh_profile/zsh_plugins.zsh

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zdharma-continuum/zinit-annex-bin-gem-node

zinit for \
    light-mode \
    zsh-users/zsh-autosuggestions \
    light-mode \
    zdharma-continuum/fast-syntax-highlighting \
    zdharma-continuum/history-search-multi-word \
    light-mode \
    pick"async.zsh" \
    src"pure.zsh" \
    sindresorhus/pure

zi ice \
  as"program" \
  atclone"rm -f src/auto/config.cache; ./configure" \
  atpull"%atclone" \
  make \
  pick"src/vim"
zi light vim/vim

zi ice atclone"dircolors -b LS_COLORS > c.zsh" atpull'%atclone' pick"c.zsh" nocompile'!'
zi light trapd00r/LS_COLORS

zi ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' src"zhook.zsh"
zi light direnv/direnv

autoload -Uz compinit
compinit

zi as'null' lucid sbin wait'1' for \
  Fakerr/git-recall \
  davidosomething/git-my \
  iwata/git-now \
  paulirish/git-open \
  paulirish/git-recent \
  atload'export _MENU_THEME=legacy' \
  arzzen/git-quick-stats \
  make'install' \
  tj/git-extras \
  make'GITURL_NO_CGITURL=1' \
  sbin'git-url;git-guclone' \
  zdharma-continuum/git-url

# -q is for quiet; actually run all the `compdef's saved before `compinit` call
# (`compinit' declares the `compdef' function, so it cannot be used until
# `compinit` is ran; Zinit solves this via intercepting the `compdef`-calls and
# storing them for later use with `zinit cdreplay`)

zinit cdreplay -q

zinit light Aloxaf/fzf-tab

zi for \
    atload"zicompinit; zicdreplay" \
    blockf \
    lucid \
    wait \
    zsh-users/zsh-completions

zi wait lucid for \
  z-shell/zsh-fancy-completions

zinit light z-shell/F-Sy-H

zinit pack for ls_colors

zinit \
    atclone'[[ -z ${commands[dircolors]} ]] &&
      local P=${${(M)OSTYPE##darwin}:+g};
      ${P}sed -i '\''/DIR/c\DIR 38;5;63;1'\'' LS_COLORS;
      ${P}dircolors -b LS_COLORS >! clrs.zsh' \
    atload'zstyle '\'':completion:*:default'\'' list-colors "${(s.:.)LS_COLORS}";' \
    atpull'%atclone' \
    git \
    id-as'trapd00r/LS_COLORS' \
    lucid \
    nocompile'!' \
    pick'clrs.zsh' \
    reset \
  for @trapd00r/LS_COLORS

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source $HOME/.local/share/lscolors.sh
