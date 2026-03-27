#!/usr/bin/env zsh

latest_url="$(curl --show-headers 'https://github.com/nextflow-io/language-server/releases/latest' 2>/dev/null | grep location: | sed 's/location: //')"
version="$(echo "$latest_url" | sed 's/.*tag\///')"
lsp_url="$latest_url/language-server-all.jar"

echo "$latest_url"
echo "$version"
echo "$lsp_url"
