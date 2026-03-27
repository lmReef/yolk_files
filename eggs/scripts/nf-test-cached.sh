#!/bin/zsh

tags=""
while [[ "$1" =~ "--tag" ]]; do
    tags+="$2"
    shift 2
done

# echo -e "\ntags: $tags\n"

tagged_tests=""

for test in "$(fd -e nf.test)";do
    if grep -qE "tag \"($(sed 's/ /|/g' <<<"$tags"))\"" <"$test"; then
        echo "tag found in test $test"
    fi
done

# cache_dir=".nf-test/custom-cache"
# mkdir -p "$cache_dir" &>/dev/null
