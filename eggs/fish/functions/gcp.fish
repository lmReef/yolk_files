function gcp --wraps='gcloud storage cp' --description 'alias gcp gcloud storage cp'
  gcloud storage cp $argv
        
end
