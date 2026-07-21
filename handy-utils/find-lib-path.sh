#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# 
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
MULTIARCH="$3"

#拆分路径到数组.
IFS=':' read -r -a CHK_LIST <<< "${PREFIX}"

#拆分到数组.
IFS='-' read -r -a MA_ITEM <<< "${MULTIARCH}"

#
if [ "${MA_ITEM[0]}" == "x86_64" ];then
{
    BITWIDE="64"
}
elif [ "${MA_ITEM[0]}" == "aarch64" ] || [ "${MA_ITEM[0]:0:5}" == "armv8" ];then
{
    BITWIDE="64"
}
elif [ "${MA_ITEM[0]}" == "arm" ] || [ "${MA_ITEM[0]:0:5}" == "armv7" ];then
{
    BITWIDE="32"
}
else
{
    BITWIDE=""
}
fi

#
for ONE_PATH in "${CHK_LIST[@]}"; do
{
    #
    if [ "${ONE_PATH}" == "" ];then
        continue;
    fi

    #
    SUB_LIST+=("${ONE_PATH}")
    SUB_LIST+=("${ONE_PATH}/lib${BITWIDE}")
    SUB_LIST+=("${ONE_PATH}/lib")
    SUB_LIST+=("${ONE_PATH}/lib/${MULTIARCH}")
    SUB_LIST+=("${ONE_PATH}/${MULTIARCH}/lib")
    
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
