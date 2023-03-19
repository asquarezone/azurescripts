#!/bin
function assign_default_value_if_empty() {
    value=$1
    if [[ -z $value ]]; then
        value=$2
    fi
    echo $value
}




