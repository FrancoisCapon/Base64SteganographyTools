#!/usr/bin/env bash

source $(dirname $0)/b64stegano_common.sh

function handle_line
{
    if [[ ${line: -2} == '==' ]]
    then # == 4 bits
        regular_character=${line: -3:1}
        bits_to_hidde=${bits_of_message: 0:4}
        if [[ ${#bits_to_hidde} -lt 4 ]]
        # fill the padding of the last chunck of the binary chain
        then 
            bits_to_hidde+=000
            bits_to_hidde=${bits_to_hidde: 0:4}    
        fi
        bits_to_hidde=${bits_to_hidde: 0:4}
        bits_of_message=${bits_of_message: 4}
        stegano_character=${four_hidden_bits[$regular_character:$bits_to_hidde]}
        line=${line: 0:-3}$stegano_character==
    else # = 2 bits
        regular_character=${line: -2:1}
        bits_to_hidde=${bits_of_message: 0:2}
        if [[ ${#bits_to_hidde} -lt 2 ]]
        then 
            bits_to_hidde+=0   
        fi
        bits_of_message=${bits_of_message: 2}
        stegano_character=${two_hidden_bits[$regular_character:$bits_to_hidde]}
        line=${line: 0:-2}$stegano_character=
    fi
    echo "$line" >> "$file_out"
}

function convert_message_to_binary
{
    for (( i=0; i<${#message}; i++))
    do
        character="${message: $i:1}"
        bits=$(echo $(chr2bin "$character"))
        bits=${bits: -$NBOTC}
        bits_of_message+=$bits
    done
}

function fill_arrays
{
    for i in ${!characters[@]}
    do
        character=$(character2key ${characters[i]})
        
        two_bits_index=$(($i % 4))
        if [[ $two_bits_index == 0 ]]
        then
            two_bits_regular_character=$character
        fi
        two_hidden_bits[$two_bits_regular_character:${two_bits[$two_bits_index]}]=$character
        
        four_bits_index=$(($i % 16))
        if [[ $four_bits_index == 0 ]]
        then
            four_bits_regular_character=$character
        fi
        four_hidden_bits[$four_bits_regular_character:${four_bits[$four_bits_index]}]=$character
    done
}

readonly message=$1
readonly file_in=$2
readonly file_out=$3;

rm $file_out 2> /dev/null

declare -A two_hidden_bits  # key (regular_character:hidden_bits) => value character
declare -A four_hidden_bits # same
fill_arrays

bits_of_message=""
convert_message_to_binary

while read line
do
    if [[ $bits_of_message != "" ]]
    then
        if [[ ${line: -1} == '=' ]]
        then
            handle_line
        else
            echo "$line" >> "$file_out"
        fi
    else
        echo "$line" >> "$file_out"
    fi 
done < $file_in
echo -e "Remaining bits to hide (must be empty): "$bits_of_message'\n'