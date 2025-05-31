#!/bin/sh

[ -z "$1" ] && echo "missing contact email" && exit 1

letter="ฮ"
from=1
to=17
per_batch=10

count="$((to-from))"
batch_count="$(((count / per_batch) + 1))"
done=false
for i in $(seq 0 $((batch_count-1))); do
  for j in $(seq 0 $((per_batch-1))); do
    current="$((i*per_batch +j+from))"
    if [ "$current" -gt "$to" ]; then
      done=true
    fi

    if $done; then
      break
    fi

    curl -k "https://dictionary.orst.go.th/Lookup/lookupDomain.php?page=${current}&domain=${letter}" \
      --compressed \
      -H "User-Agent: Dictionary Scraper / Contact: $1" \
      -H "Connection: close" \
      -H "Accept-Encoding: gzip, deflate, br, zstd" \
      -H "Cache-Control: no-cache" \
      -o "${letter}_${current}.json"
  done
  if $done; then
    break
  fi
  sleep 1
done
