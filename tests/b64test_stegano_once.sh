#!/usr/bin/env bash
rm man*.txt
man ls > man.txt
echo ""
echo '* Encode text lines of man ls'
../tools/b64_encode.sh man.txt man_b64.txt
if [[ "" == "$1" ]]
then
    message="Hello steganography in base64!"
else
    message="$1"
fi
echo -e "* Hide message \e[32m$message\e[0m in text lines base64"
../tools/b64stegano_hide.sh "$message" man_b64.txt man_b64_message.txt
echo '* Detect non regular text base64 lines'
../tools/b64stegano_detect.sh man_b64_message.txt
echo '* Retrieve the message'
../tools/b64stegano_retrieve.sh man_b64_message.txt
echo "* Check that hiding the message don't alter the decoding"
../tools/b64_decode.sh man_b64_message.txt man_b64_message_decoded.txt
diff -s man.txt man_b64_message_decoded.txt
echo ""