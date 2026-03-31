function zd --description "fzf > fd > z"
    set -l RELOAD 'reload:fd -td -c always {q} || :'
    set -l OPENER 'z {1}'
    fzf --disabled --ansi --multi --with-shell 'fish -c' \
        --bind "start:$RELOAD" --bind "change:$RELOAD" \
        --bind "enter:become:$OPENER" \
        --delimiter : \
        --preview 'lst --depth 2 --icon always {1}' \
        --query "$argv"
end
