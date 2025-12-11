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
if [ $# -ne 3 ];then
    exit 22
fi

#
NAME="$1"
PREFIX="$2"
MACHINE="$3"

#拆分路径到数组.
IFS=':' read -r -a CHK_LIST <<< "${PREFIX}"

#
for ONE_PATH in "${CHK_LIST[@]}"; do
{
    #
    SUB_LIST+=("${ONE_PATH}")
    SUB_LIST+=("${ONE_PATH}/lib64")
    SUB_LIST+=("${ONE_PATH}/lib")
    SUB_LIST+=("${ONE_PATH}/lib64/${MACHINE}")
    SUB_LIST+=("${ONE_PATH}/lib/${MACHINE}")
    SUB_LIST+=("${ONE_PATH}/${MACHINE}")
    SUB_LIST+=("${ONE_PATH}/${MACHINE}/lib64")
    SUB_LIST+=("${ONE_PATH}/${MACHINE}/lib")
    
    for SUB_PATH in "${SUB_LIST[@]}"; do
    {
    	#
	if [ -f "${SUB_PATH}/lib${NAME}.so" ] || [ -L "${SUB_PATH}/lib${NAME}.so" ]||
	   [ -f "${SUB_PATH}/lib${NAME}.a" ] || [ -L "${SUB_PATH}/lib${NAME}.a" ]||
	   [ -f "${SUB_PATH}/${NAME}.so" ] || [ -L "${SUB_PATH}/${NAME}.so" ]||
	   [ -f "${SUB_PATH}/${NAME}.a" ] || [ -L "${SUB_PATH}/${NAME}.a" ]||
	   [ -f "${SUB_PATH}/${NAME}" ] || [ -L "${SUB_PATH}/${NAME}" ];then
        {
            echo "${SUB_PATH}"
            exit 0
	}
	fi
    }
    done
}
done

#
exit 1
