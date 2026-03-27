if status is-interactive
    set --global fish_key_bindings fish_default_key_bindings

    set -a PATH \
        ~/.local/bin \
        ~/.local/bin/scripts

    set -x EDITOR nvim

    # set up tools
    if test -d /home/linuxbrew/
        /home/linuxbrew/.linuxbrew/bin/brew shellenv fish | source
        for i in /home/linuxbrew/.linuxbrew/share/fish/vendor_completions.d/*
            source $i
        end
    end
    mise activate fish | source
    zoxide init fish | source
    fzf --fish | source
end
