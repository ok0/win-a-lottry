#!/bin/bash

#
# var
#
TRY="10000"
IS_WIN="0"
WINNING_NUMBERS=()
MY_NUMBERS=()

#
# generate random numbers
#
get_random_numbers()
{
    _created_count="0"
    _numbers_count="5"
    _tmp_numbers=()
    MY_NUMBERS=()
    while [ "${_created_count}" -lt "${_numbers_count}" ]
    do
        seed=$(head -1 /dev/urandom | od -N 2 | awk '{ print $2 }')
        RANDOM=${seed}
        _random_number=$((${RANDOM}%45+1))

        _is_in="0"
        for _number in "${_tmp_numbers}"; do
            if [[ "${_number}" = "${_random_number}" ]]; then
                _is_in="1"
            fi
        done

        if [[ "${_is_in}" == "0" ]]; then
            _tmp_numbers+=(${_random_number})
            let "_created_count += 1"
        fi
    done

    MY_NUMBERS=`echo ${_tmp_numbers[@]} | tr ' ' '\n' | sort --human-numeric-sort | tr '\n' ' '`
}

#
# are u winning ?
#
is_win()
{
    _win=`echo ${WINNING_NUMBERS[@]}`
    _my=`echo ${MY_NUMBERS[@]}`
    if [[ "$_win" = "$_my" ]]; then
        IS_WIN="1"
    fi
}

run()
{
    _try="0"
    while [ "${_try}" -lt "${TRY}" ]
    do
        let "_try += 1"
        get_random_numbers
        is_win

        echo "TRY: ${_try}, WIN: ${WINNING_NUMBERS[@]}, MY: ${MY_NUMBERS[@]}"
        if [[ "${IS_WIN}" = "1" ]]; then
            echo "YON WIN !"
            exit 0
        fi
    done
}


#
# Shoot !
#
YOU_DID="0"
while :
do
    get_random_numbers
    WINNING_NUMBERS=${MY_NUMBERS[@]}

    let "YOU_DID += 1"

    run
    echo "....... YOU DID ... ${YOU_DID}"

    sleep 5
done