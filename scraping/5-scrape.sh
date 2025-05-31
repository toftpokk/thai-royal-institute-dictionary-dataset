#!/bin/sh

[ -z "$1" ] && echo "missing contact email" && exit 1
[ -z "$2" ] && echo "missing input file" && exit 1

[ ! -f "$2" ] && echo "input file is not a file" && exit 1

word=""
filename=$(basename "$2")

per_batch=10
start_at=290

index=0
while read -r word; do
  if [ "$((index+1))" -lt "${start_at}" ]; then
    index="$((index+1))"
    continue
  fi

  if [ "$((index % per_batch))" -eq "0" ]; then
    sleep 10
  fi

  echo "$line"
  curl -k 'https://dictionary.orst.go.th/func_lookup.php' \
    --compressed \
    -X POST \
    -H "User-Agent: Dictionary Scraper / Contact: $1"  \
    -H 'Accept: */*' \
    -H 'Accept-Encoding: gzip, deflate, br, zstd' \
    -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
    -H 'Origin: https://dictionary.orst.go.th' \
    -H 'Connection: close' \
    -H 'Cache-Control: no-cache' \
    --data-raw "word=${word}&funcName=lookupWord&status=domain" \
    -o "${index}_${filename}_${word}.html"
  index="$((index + 1))"
done < "$2"
