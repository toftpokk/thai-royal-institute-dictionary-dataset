#!/usr/bin/env bash

set -euo pipefail

[ -z "$1" ] && echo "missing json parent input folder" && exit 1
[ -z "$2" ] && echo "missing json output folder" && exit 1

for dir in $1/*; do
  dir_name="${dir##*/}"

  mkdir -p "$2"
  jq "{data: ., word: input_filename | sub(\"^.*\/[0-9]*_words_..txt_\";\"\") | sub(\".json\$\";\"\")} " "$dir"/* \
  | jq -s "reduce .[] as \$x ([]; . + [\$x])" > "$2/$dir_name.json"
done
