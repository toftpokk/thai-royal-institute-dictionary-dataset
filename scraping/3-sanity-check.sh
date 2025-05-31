#!/bin/bash

[ -z "$1" ] && echo "needs input directory argument" && exit 1

for i in $1/*; do
  printf "%s " "$i"
  ./2-extract.sh $i | sort | wc -l
done
