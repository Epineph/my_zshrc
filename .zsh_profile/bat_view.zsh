# Define a robust 'view' function with bat fallback and customization

view() {
  local theme="Monokai Extended Bright"
  local highlight=""
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

  if [[ -z "$file" ]]; then
    echo "Usage: view [-t theme] [-l line[,line]] <file>" >&2
    return 1
  fi

  if command -v bat &>/dev/null; then
    bat --set-terminal-title \
        --style="grid,header,snip" \
        --squeeze-blank \
        --theme="$theme" \
        --pager="less" \
        --decorations="always" \
        --italic-text="always" \
        --color="always" \
        --chop-long-lines \
        --tabs 2 \
        --wrap="auto" \
        --paging="never" \
        --strip-ansi="always" \
        $highlight  \
        "$file"
  else
    cat "$file"
  fi
}

