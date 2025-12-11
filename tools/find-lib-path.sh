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
SONAME="$1"
LIBDIR="$2"

#拆分路径到数组.
IFS=':' read -r -a CHK_LIST <<< "$LIBDIR"

#
for ONE_PATH in "${CHK_LIST[@]}"; do
{
    #
    if [ -f "${ONE_PATH}/lib${SONAME}.so" ] || [ -L "${ONE_PATH}/lib${SONAME}.so" ] ||
    	[ -f "${ONE_PATH}/lib${SONAME}.a" ] || [ -L "${ONE_PATH}/lib${SONAME}.a" ] || 
    	[ -f "${ONE_PATH}/${SONAME}.so" ] || [ -L "${ONE_PATH}/${SONAME}.so" ] ||
    	[ -f "${ONE_PATH}/${SONAME}.a" ] || [ -L "${ONE_PATH}/${SONAME}.a" ] || 
    	[ -f "${ONE_PATH}/${SONAME}" ] || [ -L "${ONE_PATH}/${SONAME}" ];then
    {
        echo "${ONE_PATH}"
        exit 0
    }
    fi
    
    #
    if [ -f "${ONE_PATH}/lib64/lib${SONAME}.so" ] || [ -L "${ONE_PATH}/lib64/lib${SONAME}.so" ] ||
    	[ -f "${ONE_PATH}/lib64/lib${SONAME}.a" ] || [ -L "${ONE_PATH}/lib64/lib${SONAME}.a" ] || 
    	[ -f "${ONE_PATH}/lib64/${SONAME}.so" ] || [ -L "${ONE_PATH}/lib64/${SONAME}.so" ] ||
    	[ -f "${ONE_PATH}/lib64/${SONAME}.a" ] || [ -L "${ONE_PATH}/lib64/${SONAME}.a" ] || 
    	[ -f "${ONE_PATH}/lib64/${SONAME}" ] || [ -L "${ONE_PATH}/lib64/${SONAME}" ];then
    {
        echo "${ONE_PATH}/lib64"
        exit 0
    }
    fi
   
    #
    if [ -f "${ONE_PATH}/lib/lib${SONAME}.so" ] || [ -L "${ONE_PATH}/lib/lib${SONAME}.so" ] ||
    	[ -f "${ONE_PATH}/lib/lib${SONAME}.a" ] || [ -L "${ONE_PATH}/lib/lib${SONAME}.a" ] || 
    	[ -f "${ONE_PATH}/lib/${SONAME}.so" ] || [ -L "${ONE_PATH}/lib/${SONAME}.so" ] ||
    	[ -f "${ONE_PATH}/lib/${SONAME}.a" ] || [ -L "${ONE_PATH}/lib/${SONAME}.a" ] ||
    	[ -f "${ONE_PATH}/lib/${SONAME}" ] || [ -L "${ONE_PATH}/lib/${SONAME}" ];then
    {
        echo "${ONE_PATH}/lib"
        exit 0
    }
    fi
}
done

#
exit 1
