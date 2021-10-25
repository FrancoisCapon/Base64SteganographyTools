# PARAMETERS

# NBOTC=7 # ASCII only
# NBOTC=8 # 
readonly NBOTC=8

# DATA
readonly characters=($(echo {A..Z}) $(echo {a..z}) $(echo {0..9}) + /)
readonly two_bits=($(echo {0,1}{0,1}))
readonly four_bits=($(echo {0,1}{0,1}{0,1}{0,1}))

# UTIL FUNCTIONS

# https://stackoverflow.com/questions/12855610/shell-script-is-there-any-way-converting-number-to-char
function chr
{
  printf \\$(printf '%03o' $1)
}
# https://newbedev.com/ascii-to-binary-and-binary-to-ascii-conversion-tools
function chr2bin
{
    echo -n "$1" | xxd -b | awk '{print $2}'
}

function character2key # of associative array
{
    case $1 in
        +) key='plus';;
        /) key='slash';;
        *) key=$1
    esac
    echo $key
}
