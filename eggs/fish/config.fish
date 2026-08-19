if status is-interactive
    set --global fish_key_bindings fish_default_key_bindings

    set -a PATH \
        ~/.local/bin \
        ~/.local/bin/scripts \
        ~/.cargo/bin

    set -x EDITOR nvim

    # set up tools
    mise activate fish | source
    zoxide init fish | source
    fzf --fish | source
    jj util completion fish | source
    wezterm shell-completion --shell fish | source

    # pnpm
    set -gx PNPM_HOME "$HOME/.local/share/pnpm"
    if not string match -q -- "$PNPM_HOME/bin" $PATH
        set -gx PATH "$PNPM_HOME/bin" $PATH
    end
    # pnpm end
end
