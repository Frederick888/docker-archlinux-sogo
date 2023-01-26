#!/usr/bin/env bash

printf "READY\n"

while read -r line; do
    echo "Processing Event: $line" >&2
    supervisorctl shutdown
done </dev/stdin
