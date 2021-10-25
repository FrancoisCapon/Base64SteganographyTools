#!/usr/bin/env bash
rm man*.txt
man ls > man.txt
../tools/b64_encode.sh man.txt man_b64.txt
../tools/b64_decode.sh man_b64.txt man_b64_decoded.txt
diff -s man.txt man_b64_decoded.txt