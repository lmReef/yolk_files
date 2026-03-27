function lst --wraps=ls\ -R\ --ignore=\'.git\' --description alias\ lst\ ls\ -R\ --ignore=\'.git\'
    lsd --tree \
        -I .git \
        -I .github \
        -I ".nf-test*" \
        $argv

end
