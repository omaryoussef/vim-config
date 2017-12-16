
command -v fzf >/dev/null 2>&1 || { exit 0; }

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --glob "!{.git,node_modules}/*"'

fzf-ctrlp-widget() {
    local file="$(__fsel)"
    local ret=$?
    file="$(echo -e "${file}" | sed -e 's/[[:space:]]*$//')"
    # Open the file if it exists
    if [ -n "$file" ]; then
    </dev/tty vim "$file"
    fi
    zle redisplay
    typeset -f zle-line-init >/dev/null && zle zle-line-init
    return $ret
}

zle -N fzf-ctrlp-widget

bindkey "^p" fzf-ctrlp-widget

command -v rg >/dev/null 2>&1 || { exit 0; }

_fzf_compgen_path() {
    rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null
    #rg --files --hidden --no-ignore --no-messages
}
