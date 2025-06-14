# ----------------------------------------------------------------------------
# File: ~/.zsh_profile/identify_amd_drivers.zsh
#
# This function inspects your GPU via `lspci` and sets environment variables
# for Hyprland (or any Wayland session) depending on whether you have an AMD,
# NVIDIA, Intel, or another GPU.
#
# Usage:
#   identify_amd_drivers [--info|-v|--verbose]
#
# If one of the verbose flags is provided, informational messages will be echoed.
#
# It is autoloaded by sourcing all *.zsh files in your ~/.zsh_profile.
# ----------------------------------------------------------------------------

identify_amd_drivers() {
  # Set VERBOSE flag to 0 (silent) by default.
  local VERBOSE=0

  # Parse function arguments looking for verbose flags.
  for arg in "$@"; do
    case "$arg" in
      -v|--verbose|--info)
        VERBOSE=1
        ;;
    esac
  done

  # Helper function for conditional echo.
  vecho() {
    if [[ $VERBOSE -eq 1 ]]; then
      echo "$@"
    fi
  }

  # 1. Retrieve GPU information.
  local GPU_INFO
  GPU_INFO="$(lspci -k | grep -EA2 'VGA|3D|Display')"

  vecho "[INFO] Detected GPU Info:"
  vecho "$GPU_INFO"
  vecho ""

  # 2. Detect GPU vendor and set the corresponding environment variables.
  if echo "$GPU_INFO" | grep -qi "nvidia"; then
    vecho "[INFO] NVIDIA GPU detected."
    # NVIDIA-specific environment variables.
    export __GLX_VENDOR_LIBRARY_NAME="nvidia"
    export __GL_GSYNC_ALLOWED="1"
    export __NV_PRIME_RENDER_OFFLOAD="1"
    export __VK_LAYER_NV_optimus="NVIDIA_only"
    vecho "[INFO] NVIDIA environment variables set."

  elif echo "$GPU_INFO" | grep -qi "amdgpu"; then
    vecho "[INFO] AMD GPU (amdgpu kernel module) detected (GCN or newer)."
    # Environment variables for AMD with the newer amdgpu driver.
    export LIBVA_DRIVER_NAME="radeonsi"    # VAAPI driver for GCN-based AMD.
    export AMD_VULKAN_ICD="radv"           # Use Mesa RADV driver.
    export RADV_PERFTEST="aco,ngg"
    vecho "[INFO] AMD (radeonsi, radv) environment variables set."

  elif echo "$GPU_INFO" | grep -qi "radeon"; then
    vecho "[INFO] AMD GPU (radeon kernel module) detected (older TeraScale)."
    # Environment variables for older AMD hardware.
    export LIBVA_DRIVER_NAME="r600"
    vecho "[INFO] TeraScale environment variables (r600) set."

  elif echo "$GPU_INFO" | grep -qi "intel"; then
    vecho "[INFO] Intel GPU detected."
    # Intel-specific VAAPI driver.
    export LIBVA_DRIVER_NAME="iHD"  # Adjust as needed (e.g., iHD or i965).
    vecho "[INFO] Intel environment variables set."

  else
    vecho "[WARN] Unrecognized or hybrid GPU. No specific environment variables set."
  fi

  # 3. Set common Hyprland (Wayland) environment variables.
  export XDG_CURRENT_DESKTOP="Hyprland"
  export XDG_SESSION_DESKTOP="Hyprland"
  export XDG_SESSION_TYPE="wayland"
  export GDK_BACKEND="wayland,x11,*"
  export QT_QPA_PLATFORM="wayland;xcb"
  export CLUTTER_BACKEND="wayland"
  export EDITOR="nvim"
  export MOZ_ENABLE_WAYLAND="1"
  export ELECTRON_OZONE_PLATFORM_HINT="auto"

  # Set scaling defaults.
  export GDK_SCALE="1"
  export QT_SCALE_FACTOR="1"

  vecho "[INFO] Common Hyprland environment variables exported."
}
identify_amd_drivers