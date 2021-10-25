binaries=($(echo {0,1}{0,1}{0,1}{0,1}{0,1}{0,1}))
integers=($(echo {0..63}))
characters=($(echo {A..Z}) $(echo {a..z}) $(echo {0..9}) + /)

rm b64_characters_table.txt 2> /dev/null

for i in ${!binaries[@]}
do
    echo -e ${binaries[$i]}'\t'${integers[$i]}'\t'${characters[$i]} >> b64_characters_table.txt
done
echo -e "\n* Table of base64 encoding characters"
head -n 12 b64_characters_table.txt
echo "..."
tail -n 12 b64_characters_table.txt

echo -e "\n* List of REGULAR characters with FOUR padding bits (string ends with ==)"
echo $(cat b64_characters_table.txt | grep $'0000\t' | cut -f 3 ) [$(cat b64_characters_table.txt | grep $'0000\t' | cut -f 3 | tr -d '\n')]

echo -e "\n* List of IRREGULAR characters with FOUR padding bits (string ends with ==)"
echo $(cat b64_characters_table.txt | grep -v $'0000\t' | cut -f 3 ) [$(cat b64_characters_table.txt | grep -v $'0000\t' | cut -f 3 | tr -d '\n')]

echo -e "\n* List of REGULAR characters with TWO padding bits (string ends with =)"
echo $(cat b64_characters_table.txt | grep $'00\t' | cut -f 3 )  [$(cat b64_characters_table.txt | grep $'00\t' | cut -f 3 | tr -d '\n')]

echo -e "\n* List of IRREGULAR characters with TWO padding bits (string ends with =)"
echo $(cat b64_characters_table.txt | grep -v $'00\t' | cut -f 3 )  [$(cat b64_characters_table.txt | grep -v $'00\t' | cut -f 3 | tr -d '\n')]

echo