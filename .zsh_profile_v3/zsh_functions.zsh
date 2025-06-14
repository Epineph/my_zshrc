# $HOME/.zsh_profile/zsh_functions.zsh

#### ─── 1) bat_wrap: your always-the-same-options + random / unique theme logic ─────────────────

# bat_wrap: wrapper around /usr/bin/bat that
#  • passes your usual flags
#  • honours $BAT_THEME if set
#  • otherwise picks one of four themes at random
#  • if you pass -t N and up to 4 files, it will assign each file a different theme
#
# Usage:
#   bat_wrap [-t N] [--] file1 [file2 …]
#
function bat_wrap() {
  # path to the real bat binary
  local BAT_CMD=$(realpath "$(which bat)")

  # your constant flags
  local BASE_OPTS=(
    --style="grid,header,snip"
    --strip-ansi="always"
    --squeeze-blank
    --squeeze-limit=2
    --paging="auto"
    --pager="less"
    --force-colorization
    --italic-text="always"
    --tabs=2
    --wrap="character"
    --terminal-width=-1
    --chop-long-lines
  )

  # the four themes you like
  local ALL_THEMES=(
    "Coldark-Dark"
    "Monokai Extended Bright"
    "Dracula"
    "gruvbox-dark"
  )

  # parse our own -t|--targets N
  local TARGET_COUNT=1
  while [[ "$1" =~ ^- ]]; do
    case $1 in
      -t|--targets)
        TARGET_COUNT=$2
        shift 2
        ;;
      --) shift; break ;;
      *)
        echo "Usage: bat_wrap [-t N] [--] file…"
        return 1
        ;;
    esac
  done

  # what you actually passed as filenames
  local FILES=( "$@" )
  (( ${#FILES[@]} )) || {
    echo "bat_wrap: need at least one file"
    return 1
  }

  # if $BAT_THEME is set, honor it: single theme for all files
  if [[ -n "$BAT_THEME" ]]; then
    for f in "${FILES[@]}"; do
      "$BAT_CMD" "${BASE_OPTS[@]}" --theme="$BAT_THEME" "$f"
    done
    return
  fi

  # otherwise, we will pick themes without replacement
  # for the first min(TARGET_COUNT,4) files
  local avail=( "${ALL_THEMES[@]}" )
  local nfiles=${#FILES[@]}
  local n_choose=$(( TARGET_COUNT < nfiles ? TARGET_COUNT : nfiles ))
  (( n_choose > ${#ALL_THEMES[@]} )) && n_choose=${#ALL_THEMES[@]}

  # build an array of assigned themes
  local assigned=()
  for ((i=0;i<n_choose;i++)); do
    # pick a random index
    local idx=$(( RANDOM % ${#avail[@]} ))
    assigned[i]="${avail[idx]}"
    # remove that theme from avail
    avail=( "${avail[@]:0:idx}" "${avail[@]:idx+1}" )
  done

  # now dispatch: for file #i < n_choose use assigned[i], else pick at random
  for ((i=0;i<nfiles;i++)); do
    local theme
    if (( i < n_choose )); then
      theme=${assigned[i]}
    else
      # pick one of the remaining (or all if we've exhausted)
      theme=${ALL_THEMES[RANDOM % ${#ALL_THEMES[@]}]}
    fi
    "$BAT_CMD" "${BASE_OPTS[@]}" --theme="$theme" "${FILES[i]}"
  done
}

# Define the function
## setup root to use vcpkg packages from users $HOME vcpkg repo in addition to installed on system root
function setup_vcpkg_env() {
  local vcpkg_root="$HOME/repos/vcpkg"
  local installed_lib="$vcpkg_root/installed/x64-linux/lib/pkgconfig"
  local pkg_config_default=$(pkg-config --variable pc_path pkg-config)
  local combined_path="${pkg_config_default}:${PKG_CONFIG_PATH:+$PKG_CONFIG_PATH:}${installed_lib}"

  # Export environment variables
  export VCPKG_ROOT="$vcpkg_root"
  export PATH="$VCPKG_ROOT:$PATH"
  export CMAKE_PREFIX_PATH="$VCPKG_ROOT/installed"
  export PKG_CONFIG_PATH="$combined_path"
  export LD_LIBRARY_PATH="$VCPKG_ROOT/installed/x64-linux/lib:$LD_LIBRARY_PATH"
}

# Automatically call the function at shell startup
setup_vcpkg_env

function clone() {
  local repo=$1
  local target_dir=$REPOS

  # Define the build directory for AUR packages
  local build_dir=~/build_src_dir
  mkdir -p "$build_dir"

    # Clone AUR packages
  if [[ $repo == http* ]]; then
    if [[ $repo == *aur.archlinux.org* ]]; then
      # Clone the AUR repository
      git -C "$build_dir" clone "$repo"
      local repo_name=$(basename "$repo" .git)
      pushd "$build_dir/$repo_name" > /dev/null

      # Build or install based on the second argument
      if [[ $target_dir == "build" ]]; then
        makepkg --syncdeps
      elif [[ $target_dir == "install" ]]; then
    makepkg -si
      fi
      popd > /dev/null
    else
      # Clone non-AUR links
      git clone "$repo" "$target_dir"
    fi
  else
    # Clone GitHub repos given in the format username/repository
    # Ensure the target directory for plugins exists
    # mkdir -p "$target_dir"
    git -C "$REPOS" clone \
      "https://github.com/$repo.git" \
      --recurse-submodules
  fi

}

function addalias() {
  echo "alias $1='$2'" | sudo tee -a ~/.zshrc
  freshZsh
}

function scp_transfer() {
  local direction=$1
  local src_path=$2
  local dest_path=$3
  local host_alias=$4

  # Retrieve the actual host address from the alias
  local host_address=$(eval echo "\$$host_alias")

  if [[ $direction == "TO" ]]; then
    scp $src_path ${host_address}:$dest_path
  elif [[ $direction == "FROM" ]]; then
    scp ${host_address}:$src_path $dest_path
  else
    echo "Invalid direction. Use TO or FROM."
  fi
}



function git_pull_all() {
    # Store the current directory
  local current_dir=$(pwd)

  # Iterate over each directory in the current directory
  for dir in */; do
  # Check if the directory is a git repository
    if [ -d "${dir}/.git" ]; then
      echo "Updating ${dir}..."
      cd "${dir}" || return # Change to the directory
                            # or exit on failure
            
      # Optionally, checkout a specific branch.
      # Remove or modify as needed.

      git stash && git checkout && git pull
      
      git config --global --add \
        safe.directory "${dir}"
      
      # Pull the latest changes
      # git pull

      # Return to the original directory
      cd "${current_dir}" || return
    else
      echo "${dir} is not a git repository."
    fi
done
}

# fzf_edit - Use fzf to select a file and open it in an editor.
#
# This function uses the fzf fuzzy finder to select a file using the fd command.
# It displays a preview of each file using bat with a custom style.
#
# Usage:
#   fzf_edit [-e|--editor <editor>]
#
# Options:
#   -e, --editor <editor>  Specifies the editor to use.
#
# If no editor is specified using the option, the function defaults to the
# environment variable EDITOR. If EDITOR is not set, it further defaults to "vim".

function fzf_edit() {
  # Default editor: use EDITOR if set, otherwise fallback to "vim".
  local editor="${EDITOR:-vim}"

  # Define bat preview style options.
  local bat_style='--style="grid,header,snip" \
    --color=always --theme="gruvbox-dark"\
    --squeeze-blank --chop-long-lines --tabs 2\
    --wrap="auto" --paging="never"\
    --strip-ansi="always" --italic-text="always"\
    --line-range :500'

  # Option parsing: Check for -e or --editor arguments.
  while [[ $# -gt 0 ]]; do
    case $1 in
      -e|--editor)
        if [[ -n $2 ]]; then
          editor="$2"
          shift 2  # Remove the option
                   # and its parameter.
        else
          echo "Error: -e|--editor requires \
            an argument." >&2
          return 1
        fi
        ;;
      *)
        echo "Usage: fzf_edit [-e|--editor\
          <editor>]" >&2
        return 1
        ;;
    esac
  done

  # Use fd to list files and fzf to select one,
  # while previewing with bat.
  local file
  file=$(fd --type f | fzf --preview \
    "bat $bat_style {}"\
    --preview-window=right:60%:wrap)
  
  # If a file was selected, open it using 
  # sudo and the chosen editor.
  if [[ -n $file ]]; then
    sudo "$editor" "$file"
  fi
}

#### ─── 2) git_pull_all: auto-allow direnv ────────────────────────────────────────────────────

function gh_pull_all() {
  local current_dir=$(pwd)

  for dir in */; do
    # only look at real git repos
    if [[ -d "${dir}/.git" ]]; then
      echo "→ Updating ${dir%/} …"
      cd "$dir" || return

      # if there is an .envrc, allow it
      if [[ -f .envrc ]]; then
        echo "  • Found .envrc, running direnv allow…"
        sudo direnv allow || echo "    ✖ direnv allow failed"
      fi

      # stash, checkout default, pull
      git stash && git checkout && git pull
      git config --global --add safe.directory "$(pwd)"

      cd "$current_dir" || return
    else
      echo "⚠  ${dir%/} is not a git repo, skipping."
    fi
  done
}

# A wrapper function to call git diff with
# custom delta options

function dgit_diff() {
  # Combine git diff with delta options
  # --side-by-side and --navigate are passed explicitly if not already set in the config file
  git diff "$@" | delta --side-by-side --navigate
}

# SmartCat: pipes stdin into bat if available, else cat.
function smartcat() {
  if command -v bat &>/dev/null; then
    bat --style="grid,header,snip" \
      --strip-ansi="always" --squeeze-blank \
      --squeeze-limit=2 --theme="gruvbox-dark"\
      --paging="auto" --pager="less" \
      --force-colorization --italic-text="always"\
      --tabs=2 --wrap="character" \
      --terminal-width=-1 --chop-long-lines
  else
    cat
  fi
}
#smartcat
# Replace `cat` **only** when scipts call it non-interactively:
alias cat='smartcat'

