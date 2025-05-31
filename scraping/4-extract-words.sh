#!/bin/bash

[ -z "$1" ] && echo "needs input directory argument" && exit 1

for i in $1/*; do
  name="$(basename $i)"
  ./2-extract.sh "$i" | sort > "words_$name.txt"
done
