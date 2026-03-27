function cl --wraps=csvlens --description 'alias cl csvlens'
    if string match -rq '^gs://' $argv
        gcat $argv | csvlens
    else
        csvlens $argv
    end
end
