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
MULTIARCH="$3"

#拆分路径到数组.
IFS=':' read -r -a CHK_LIST <<< "${PREFIX}"

#
for ONE_PATH in "${CHK_LIST[@]}"; do
{
    #
    SUB_LIST+=("${ONE_PATH}")
    SUB_LIST+=("${ONE_PATH}/bin")
    SUB_LIST+=("${ONE_PATH}/sbin")
    SUB_LIST+=("${ONE_PATH}/bin/${MULTIARCH}")
    SUB_LIST+=("${ONE_PATH}/sbin/${MULTIARCH}")
    SUB_LIST+=("${ONE_PATH}/${MULTIARCH}")
    SUB_LIST+=("${ONE_PATH}/${MULTIARCH}/bin")
    SUB_LIST+=("${ONE_PATH}/${MULTIARCH}/sbin")
    
    for SUB_PATH in "${SUB_LIST[@]}"; do
    {
    	#
	    if [ -f "${SUB_PATH}/${NAME}" ] || [ -L "${SUB_PATH}/${NAME}" ];then
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
