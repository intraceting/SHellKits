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
    export PKG_CONFIG_LIBDIR=${ONE_PATH}:${ONE_PATH}/lib64/pkgconfig:${ONE_PATH}/share/pkgconfig:${ONE_PATH}/lib/pkgconfig
    LD_FLAGS=$(pkg-config --cflags ${SONAME} 2>>/dev/null)
    if [ $? -eq 0 ];then
    {
    	echo "${LD_FLAGS}"
        exit 0
    }
    fi
}
done

#
exit 1
