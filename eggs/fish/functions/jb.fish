function jb --wraps='jj bookmark create' --description 'alias jb jj bookmark create'
    jj bookmark create $argv
    jj bookmark track $argv
end
