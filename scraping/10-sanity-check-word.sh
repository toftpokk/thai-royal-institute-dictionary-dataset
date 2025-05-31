#!/usr/bin/env bash

set -euo pipefail

[ -z "$1" ] && echo "missing json parent input folder" && exit 1

jq -r ".[].word" "$1"/*
