if string match -i darwin (uname) &>/dev/null
    set -x CHROME_EXECUTABLE "/Applications/Vivaldi.app/Contents/MacOS/Vivaldi"

    ssh-add --apple-use-keychain ~/.ssh/main &>/dev/null
end
