#!/bin/zsh

if [[ -z "$1" ]]; then
    echo "missing first arg SRC"
    exit 1
elif ! echo "$1" | grep -q "gs://"; then
    echo "first arg must be gs:// url"
    exit 1
elif [[ -z "$2" ]]; then
    echo "missing second arg DEST"
    exit 1
elif [[ -n "$3" ]]; then
    echo "too many args, expected cmd [SRC] [DEST]"
    exit 1
fi
# TODO: parse all gcloud storage cp args so the script can wrap it fully

gcs_cache_dir="$HOME/.cache/gcs_cache"

if [[ ! -d "$gcs_cache_dir" ]]; then
    mkdir "$gcs_cache_dir"
fi
if [[ ! -d "$(dirname "$2")" ]]; then
    mkdir -p "$(dirname "$2")"
fi

filename="$(basename "$1")"
cached_file="$gcs_cache_dir/$filename"

if [[ ! -f "$cached_file" ]]; then
    echo "no cached file found in $gcs_cache_dir"
    gcloud storage cp "$1" "$cached_file"
else
    echo "copying cached file found $cached_file"
fi

cp "$cached_file" "$2"
