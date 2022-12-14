#!/usr/bin/env sh
#
# author    : Felipe Mattos
# date      : 12/13/2022
# app       : whatever
# app layer : whatever
# version   : 0.1
#
# purpose   : random names and ids generator. names are based on LOTR and id's are (almost) whatever wanted
# remarks   : shameless stole it from docker names-generator package
# require   : bourne sh, reading capability and...
    _deps="fold xargs"
#
# change log:
#

# check dependencies
for _dep in ${_deps}; do
    if ! command -v "${_dep}" 1>&2> /dev/null; then
        echo "ERROR: ${_dep} required"
        exit 127
    fi
done

# show usage
usage() {
    echo 
    echo "Generate random IDs or names built of an adjective + a LOTR character name :)"
    echo
    echo "Usage:"
    echo "  $0 [-t type] [-m id_model]"
    echo
    echo "Where type in:"
    echo "  name    : generate a random LOTR name"
    echo "  id      : generate a random ID"
    echo
    echo "When generating IDs you can specify id_model, as of:"
    echo "      [8|16|32 as bytes] [l|u|c as case]"
    echo "      * l = lower / u = upper / c = camel"
    echo
    echo "Example"
    echo "  Generate a 8bytes lower case id"
    echo "  $0 -t id -m 8l"
    echo
    echo "  Valid values for id_model are:"
    echo "      8l|8u|8c    : 8 bytes ID, lower(l) / upper(u) / canel(c) case"
    echo "      16l|16u|16c : 8 bytes ID, lower(l) / upper(u) / canel(c) case"
    echo "      32l|32u|32c : 8 bytes ID, lower(l) / upper(u) / canel(c) case"
    echo
    echo "  * if id_model is omitted 16c (16 bytes/camel case) will be used"
    echo
    exit 127
}

# make an ID based on args
makeID() {
    # get the bytes, strip all numbers from id_model
    _makeID_bytes=$(echo "${1}" | tr -d -c 0-9)
    # get the last char - I hate POSIX so much - to know which case to use
    _makeID_case=$(echo "${1}" | tr -d -c '[:lower:]')
    # build the tr params
    [ "${_makeID_case}" = "l" ] && _makeID_case="[:lower:]"
    [ "${_makeID_case}" = "u" ] && _makeID_case="[:upper:]"
    [ "${_makeID_case}" = "c" ] && _makeID_case="[:lower:][:upper:]"
    # let it roll
    _makeID_idrand=$(LC_ALL=C tr -dc \""${_makeID_case}[:digit:]"\" < /dev/urandom | tr -d "[:punct:]" | fold -w "${_makeID_bytes}" | head -n 1)
    # return
    echo "${_makeID_idrand}"
}

# make a name from _left_name and _right_name vars
makeName() {
# _left_name defines the left side - adjective - of the random name, please keep it alphabetically ordered 
_left_name="absurd admiring adventurous agitated amazing angry annoying awesome beautiful blissful bold boring brave buffoon busy cheesy clever comic cool cranky crazy cuckoo dazzling distracted eager elastic elegant enchanted ferocious foolish friendly frosty funny goofy great happy hardcore hilarious humorous hungry jolly lazy loud lovely ludicrous lunatic modest nervous pretty quiet savage sharp silly slacker sleepy smart strange sweet tired wacky waggish weird wonderful zen zombie"
# _right_name defines the right side of the random name - doh, the character - please keep it alphabetically ordered 
_right_name="aragorn arwen azog balin balrog beorn bilbo bombadil bombur borg boromir celeborn celebrimbor denethor dwalin elendil elrond faramir fili frodo galadriel gandalf gilly gimli gloin gollum isildur kili legolas meriadoc morgoth nazgul pippin proudfoot radagast samwise saruman sauron shadowfax smaug smeagol theoden thorin treebeard urukhai"
    if [ "$(uname -s)" = "Darwin" ]; then
    # running on macos - shuf not available - some makeshift
        _makeName_nameran=$(echo "${_left_name}" | tr ' ' '\n' | sort -R | head -1)
        _makeName_nameran="${_makeName_nameran}-$(echo "${_right_name}" | tr ' ' '\n' | sort -R | head -1)"
    else
    # depends on shuf which is usaully everywhere, but on macos :/
        ! [ "$(command -v shuf 1>&2> /dev/null)" ] && { echo "ERROR: shuf required"; exit 127; }
        _makeName_nameran=$(echo "${_left_name}" | xargs shuf -n1 -e)
        _makeName_nameran="${_makeName_nameran}-$(echo "${_right_name}" | xargs shuf -n1 -e)"
    fi
    # return
    echo "${_makeName_nameran}"
}

# get cmd opts
while getopts ":t:m:" _arg; do
    case "${_arg}" in
        t)
            _type="${OPTARG}"
            ;;
        m)
            _id_model="${OPTARG}"
            # make sure _id_model is valid
            if ! echo "${_id_model}" | grep -qE "^(8|16|32)(l|u|c)$"; then
                 echo "ERROR: invalid id_model" && exit 127
            fi
            ;;
        *)
            usage
            ;;
    esac
done

# make 16c default if generating an id but model is not set
[ -z "${_id_model}" ] && _id_model="16c"
# parse args and run
if [ -z "${_type}" ]; then
    usage
else
    [ "${_type}" = "name" ] && _out=$(makeName)
    [ "${_type}" = "id" ] && _out=$(makeID "${_id_model}")
fi
# return and exit
echo "${_out}" && exit 0
