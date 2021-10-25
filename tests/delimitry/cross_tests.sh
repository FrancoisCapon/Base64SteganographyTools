#!/usr/bin/env bash

NBOTC=$(head ../../tools/b64stegano_common.sh | grep '^readonly NBOTC' | cut -d'=' -f2)
if [[ $NBOTC != 8 ]]
then
    echo -e "\e[31mNBOTC must be set to 8 in ../../b64stegano_common.sh for delimitry\e[0m"
    exit 8
fi
cd ..
echo ""; echo -e "** b64test_stegano_once.sh hide \e[32mHello steganography in base64!\e[0m in ../man_b64_message.txt"; echo ""
./b64test_stegano_once.sh > /dev/null
cd delimitry
echo ""; echo "** demilitry.py on ../man_b64_message.txt"; echo ""
./delimitry.py ../man_b64_message.txt
echo ""; echo -e "** b64stegano_retrieve.sh on stegano_01.txt must retrieve \e[32mBase_sixty_four_point_five\e[0m"; echo ""
../../tools/b64stegano_retrieve.sh stegano_01.txt
