function jl --wraps='jj log' --wraps='jj log -n10' --description 'alias jl jj log -n10'
  jj log -n10 $argv
        
end
