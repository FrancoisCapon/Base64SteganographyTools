#!/usr/bin/env bash
while read -r
do
    echo "$REPLY" | base64 -d
done < $1 > $2