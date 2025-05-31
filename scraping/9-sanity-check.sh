#!/usr/bin/env bash

set -euo pipefail

[ -z "$1" ] && echo "missing json parent input folder" && exit 1

for file in $1/*; do
  dir_name="${file##*/}"

  printf "%6d %s\n" "$(jq "length" "$file")" "$dir_name" 
done
