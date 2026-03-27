function poi --wraps='poetry install --all-groups --all-extras' --description 'alias poi poetry install --all-groups --all-extras'
  poetry install --all-groups --all-extras $argv
        
end
