# $HOME/.zsh_profile/zsh_functions.zsh

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


function git_push() {
  local commit_message
  local repo_url
  local sanitized_url

  if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN is not set in your environment."
    return 1
  fi

  echo "Enter the commit message:"
  read -r commit_message

  # Add all changes to the repositor
  git add .

  # Commit the changes with the provided message
  git commit -m "$commit_message"

  # Get the repository URL and sanitize it
  repo_url=$(git config --get remote.origin.url)
  sanitized_url=$(echo "$repo_url" | sed 's|https://|https://'"$GITHUB_TOKEN"'@|')

  # Push the changes using the personal access token for authentication
  git push "$sanitized_url" main

  echo "Changes committed and pushed successfully."
}

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
    git -C "$REPOS" clone "https://github.com/$repo.git" --recurse-submodules
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
      cd "${dir}" || return # Change to the directory or exit on failure
            
      # Optionally, checkout a specific branch. Remove or modify as needed.
      git stash && git checkout && git pull
      git config --global --add safe.directory "${dir}"
      # Pull the latest changes
      # git pull

      # Return to the original directory
      cd "${current_dir}" || return
    else
      echo "${dir} is not a git repository."
    fi
done
}

function fzf_edit() {
  local bat_style='--color=always --theme="TwoDark"  --line-range :500'
  if [[ $1 == "no_line_number" ]]; then
    bat_style+=' --style=grid'
  fi

  local file
  file=$(fd --type f | fzf --preview "bat $bat_style {}" --preview-window=right:60%:wrap)
  if [[ -n $file ]]; then
    sudo vim "$file"
  fi
}

function batCat() {
    sudo "$(which bat)" --style=grid --paging=never $1 
}

