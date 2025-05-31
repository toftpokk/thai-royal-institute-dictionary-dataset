#!/bin/sh

[ -z "$1" ] && echo "needs input directory argument" && exit 1

files="$(find $1 -type f)"
cat $files | jq ".[1]" | sed -e '/\[/d' -e '/\]/d' | sed -e 's/^\s\+"//' -e 's/",\?//' | sort
