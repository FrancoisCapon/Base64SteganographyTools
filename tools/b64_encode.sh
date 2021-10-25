#!/usr/bin/env bash
while read -r # -r do not allow backslashes to escape any characters
do
    echo "$REPLY" | base64 -w 0
    echo ""
done < $1 > $2