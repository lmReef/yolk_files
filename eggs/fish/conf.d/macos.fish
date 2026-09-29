if string match -i '*macbook*' (hostname) &>/dev/null
    set -x CHROME_EXECUTABLE "/Applications/Vivaldi.app/Contents/MacOS/Vivaldi"

    ssh-add --apple-use-keychain ~/.ssh/main &>/dev/null
end
