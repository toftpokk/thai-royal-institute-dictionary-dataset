#!/usr/bin/env bash

set -euo pipefail

[ -z "$1" ] && echo "missing extraction folder" && exit 1
[ -z "$2" ] && echo "missing output folder" && exit 1

mkdir -p "$2"

for i in $1/*; do
  dir_name="${i##*/}"
  output_dir="$2/$dir_name"
  mkdir -p "$output_dir"
  for j in $i/*; do
    input_name="${j##*/}"
    output_name="${input_name%.html}"

    ./6-parse-to-json.py "$j" "$output_dir/$output_name.json"
  done
done
