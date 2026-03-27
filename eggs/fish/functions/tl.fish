function tl --wraps='csvlens -t' --description 'alias tl csvlens -t'
    if string match -rq '^gs://' $argv
        gcat $argv | csvlens -t
    else
        csvlens -t $argv
    end
end
