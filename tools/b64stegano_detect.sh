#!/usr/bin/env bash
# return code of egrep : 0 b64 steganography detected
cat $1 | egrep  --color=auto -n -e "([BCDEFGHIJKLMNOPRSTUVWXYZabcdefhijklmnopqrstuvxyz0123456789+/]==$)|([BCDFGHJKLNOPRSTVWXZabdefhijlmnpqrtuvxyz1235679+/]=$)"