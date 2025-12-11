#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# Copyright (c) 2021 The ABCDK project authors. All Rights Reserved.
# 
##

#
SHELLDIR=$(cd `dirname $0`; pwd)

#
if [ $# -ne 2 ];then
    exit 22
fi

#
HDNAME="$1"
INCDIR="$2"

#拆分路径到数组.
IFS=':' read -r -a CHK_LIST <<< "${INCDIR}"

#
for ONE_PATH in "${CHK_LIST[@]}"; do
{
    #
    if [ -f "${ONE_PATH}/${HDNAME}" ] || [ -L "${ONE_PATH}/${HDNAME}" ];then
    {
        echo "${ONE_PATH}"
        exit 0
    }
    fi
    
    #
    if [ -f "${ONE_PATH}/include/${HDNAME}" ] || [ -L "${ONE_PATH}/include/${HDNAME}" ];then
    {
        echo "${ONE_PATH}/include"
        exit 0
    }
    fi
 
    
    if [ -f "${ONE_PATH}/inc/${HDNAME}" ] || [ -L "${ONE_PATH}/inc/${HDNAME}" ];then
    {
        echo "${ONE_PATH}/inc"
        exit 0
    }
    fi
}
done

#
exit 1
