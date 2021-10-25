#!/usr/bin/env bash

source $(dirname $0)/b64stegano_common.sh

function handle_line {
    if [[ ${line: -2} == '==' ]]
    then # == 4 bits
        character=$(character2key ${line: -3:1})
        hidden_bits+=${four_hidden_bits[$character]}
    else # = 2 bits
        character=$(character2key ${line: -2:1})
        hidden_bits+=${two_hidden_bits[$character]}   
    fi
    if [[ ${#hidden_bits} -ge $NBOTC ]]
    then
        character_hidden_bits=${hidden_bits: 0:$NBOTC}
        ascii=$((2#$character_hidden_bits))
        if [[ $ascii != 0 ]]
        then
            character=$(chr $ascii)
            message+=$character
        fi
        hidden_bits=${hidden_bits: $NBOTC}
    fi
}

# -A associative array -a indexed array !!
readonly file=$1
declare -A two_hidden_bits  # key character => value hidden bits
declare -A four_hidden_bits # same
for i in ${!characters[@]}
do
    character=$(character2key ${characters[i]})
    two_hidden_bits[$character]=${two_bits[$(($i % 4))]}
    four_hidden_bits[$character]=${four_bits[$(($i % 16))]}
done
message=""
hidden_bits=""        
while read line
do
    if [[ ${line: -1} == '=' ]]
    then
        handle_line
    fi 
done < $file
echo -e "Remaining bits:\t"$hidden_bits'\n'
echo -e "Hidden message:\t"$message'\n'