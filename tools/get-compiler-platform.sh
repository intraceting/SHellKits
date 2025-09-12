#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# Copyright (c) 2025 The ABCDK project authors. All Rights Reserved.
# 
##
#
SHELLDIR=$(cd `dirname $0`; pwd)

# Functions
checkReturnCode()
{
    rc=$?
    if [ $rc != 0 ];then
        exit $rc
    fi
}

#
TARGET_MACHINE=$(${SHELLDIR}/get-compiler-machine.sh "${1}")
checkReturnCode

#
if [ "${TARGET_MACHINE}" == "" ];then
exit 127
fi

#拆分到数组中.
IFS="-" read -ra TARGET_TRIPLE_VECTOR <<< "${TARGET_MACHINE}"

if [ "${TARGET_TRIPLE_VECTOR[0]}" == "x86_64" ] || [ "${TARGET_TRIPLE_VECTOR[0]}" == "aarch64" ];then
{
    echo "${TARGET_TRIPLE_VECTOR[0]}"
}
elif [ "${TARGET_TRIPLE_VECTOR[0]}" == "armv8" ] || [ "${TARGET_TRIPLE_VECTOR[0]}" == "armv7" ] || [ "${TARGET_TRIPLE_VECTOR[0]}" == "armv6" ];then
{
    if [[ ${TARGET_TRIPLE_VECTOR[-1]} == *eabihf ]]; then
        echo "${TARGET_TRIPLE_VECTOR[0]}hl"
    elif [[ ${TARGET_TRIPLE_VECTOR[-1]} == *eabi ]]; then
        echo "${TARGET_TRIPLE_VECTOR[0]}l"
    else 
        echo "${TARGET_TRIPLE_VECTOR[0]}"
    fi
}
elif [ "${TARGET_TRIPLE_VECTOR[0]}" == "arm" ];then
{
    if [[ ${TARGET_TRIPLE_VECTOR[-1]} == *eabihf ]]; then
        echo "armv7hl"
    elif [[ ${TARGET_TRIPLE_VECTOR[-1]} == *eabi ]]; then
        echo "armv7l"
    else 
        echo "armv7"
    fi
}
else 
{
    echo "${TARGET_TRIPLE_VECTOR[0]}"
}
fi