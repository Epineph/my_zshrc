# Define a robust 'view' function with bat fallback and customization

view() {
  local bat_style="header,grid"
  local theme="Monokai Extended Bright"
  local highlight=""
  local linerange=""
  local file=""

  # Parse options
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -t|--theme)
        theme="$2"
        shift 2
        ;;
      -l|--lines)
        highlight="--highlight-line=$2"
        shift 2
        ;;
      -r|--line-range)
        linerange="--line-range=$2"
        shift 2
        ;;
      -n|--numbers)
        bat_style+=',numbers'
        shift
        ;;
      -*)
        echo "Unknown option: $1" >&2
        return 1
        ;;
      *)
        file="$1"
        shift
        ;;
    esac
  done
  echo $bat_style

  if [[ -z "$file" ]]; then
    echo "Usage: view [-t theme] [-l line[,line]] <file>" >&2
    return 1
  fi

  if command -v bat &>/dev/null; then
    bat --set-terminal-title \
        --style="$bat_style" \
        --squeeze-blank \
        --theme="$theme" \
        --pager="less" \
        --decorations="always" \
        --italic-text="always" \
        --color="always" \
        --terminal-width="-1" \
        --tabs 2 \
        --wrap="auto" \
        --paging="never" \
        --strip-ansi="always" \
        $highlight  \
        $linerange \
        "$file"
  else
    cat "$file"
  fi
}