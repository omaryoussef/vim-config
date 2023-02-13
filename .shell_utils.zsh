# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
#pasteinit() {
#  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
#  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
#}
#
#pastefinish() {
#  zle -N self-insert $OLD_SELF_INSERT
#}
#zstyle :bracketed-paste-magic paste-init pasteinit
#zstyle :bracketed-paste-magic paste-finish pastefinish

command -v fzf >/dev/null 2>&1 || { exit 0; }
command -v rg >/dev/null 2>&1 || { exit 0; }

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --glob "!{.git,node_modules}/*"'

# This is the same functionality as fzf's ctrl-t, except that the file or
# directory selected is now automatically cd'ed or opened, respectively.
fzf-open-file-or-dir() {
  local cmd="command find -L . \
    \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | sed 1d | cut -b3-"
  local out=$(eval $cmd | fzf-tmux --exit-0)

  if [ -f "$out" ]; then
    $EDITOR "$out" < /dev/tty
  elif [ -d "$out" ]; then
    cd "$out"
    zle reset-prompt
  fi
}

zle     -N   fzf-open-file-or-dir
bindkey '^P' fzf-open-file-or-dir

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           command -v tree >/dev/null 2>&1 && fzf "$@" --preview 'tree -C {} | head -200' ;;
    *)            fzf "$@" ;;
  esac
}

export FZF_CTRL_T_OPTS="
  --preview 'cat {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
