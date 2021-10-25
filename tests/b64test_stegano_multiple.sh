#!/usr/bin/env bash
echo ""
echo "* Parameter:"
echo "  Number bits of the characters: "$(head ../tools/b64stegano_common.sh | grep '^readonly NBOTC' | cut -d'=' -f2)
rm man*.txt
man ls > man.txt
man base64 >> man.txt
echo '* Encode text lines of man ls + man base64'
../tools/b64_encode.sh man.txt man_b64.txt
if [[ "" == "$1" ]]
then
    n=5
else
    n="$1"
fi
for i in $(seq "$n")
do
    echo ""; echo "** Test $i "
    hidden_message=$(cat /dev/urandom | head -c 200 | tr -cd 'A-Za-z0-9[!#$%&()*+,./:;<=>?@^_`{|}~-' )
    ../tools/b64stegano_hide.sh "$hidden_message" man_b64.txt man_b64_message.txt > /dev/null
    retrieved_message=$(../tools/b64stegano_retrieve.sh man_b64_message.txt | grep Hi | cut -f2)
    echo -e "Hidden message:\t\t$hidden_message"
    echo -e "Retrieved message:\t$retrieved_message"
    if [[ "$hidden_message" == "$retrieved_message" ]]
    then
        echo -e "\e[32mok :-)\e[0m"
    else
        echo -e "\e[31mKO :-(\e[0m"
    fi
    ../tools/b64_decode.sh man_b64_message.txt man_b64_message_decoded.txt
    diff -s man.txt man_b64_message_decoded.txt
    if [[ $? == 0 ]]
    then
        echo -e "\e[32mok :-)\e[0m"
    else
        echo -e "\e[31mKO :-(\e[0m"
    fi
done
echo ""