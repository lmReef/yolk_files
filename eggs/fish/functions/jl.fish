function jl --wraps='jj log' --wraps='jj log -n10' --description 'alias jl jj log -n10'
    jj log --reversed -n15 $argv

end
