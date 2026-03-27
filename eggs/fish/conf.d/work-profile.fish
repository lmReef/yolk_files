if test is-interactive && test (hostnamectl hostname) = work
    set -a PATH \
        ~/.local/bin/rtg-tools \
        ~/.config/tempus-app-manager/bin
end
