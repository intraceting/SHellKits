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
BINDIR="$2"

#拆分路径到数组.
IFS=':' read -r -a CHK_LIST <<< "${BINDIR}"

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
    if [ -f "${ONE_PATH}/bin/${HDNAME}" ] || [ -L "${ONE_PATH}/bin/${HDNAME}" ];then
    {
        echo "${ONE_PATH}/bin"
        exit 0
    }
    fi
 
    
    if [ -f "${ONE_PATH}/sbin/${HDNAME}" ] || [ -L "${ONE_PATH}/sbin/${HDNAME}" ];then
    {
        echo "${ONE_PATH}/sbin"
        exit 0
    }
    fi
}
done

#
exit 1
