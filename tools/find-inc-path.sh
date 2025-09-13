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
if [ $# -ne 1 ];then
    exit 22
fi

#
HDNAME="$1"

#
PKG_BITWIDE=${_3RDPARTY_PKG_BITWIDE}
PKG_FIND_ROOT=${_3RDPARTY_PKG_FIND_ROOT}
PKG_FIND_MODE=${_3RDPARTY_PKG_FIND_MODE}

#修复默认值。
if [ "${PKG_FIND_ROOT}" == "" ];then
PKG_FIND_MODE="default"
fi

#修复默认值。
if [ "${PKG_BITWIDE}" == "" ];then
PKG_BITWIDE="64"
fi

#
if [ "${PKG_FIND_MODE}" == "only" ];then
{
    CHK_LIST+=("${PKG_FIND_ROOT}/include/")
}
elif [ "${PKG_FIND_MODE}" == "both" ];then
{
    CHK_LIST+=("${PKG_FIND_ROOT}/include/")
    CHK_LIST+=("/usr/local/include/")
    CHK_LIST+=("/usr/include/")
    
}
else
{
    CHK_LIST+=("/usr/local/include/")
    CHK_LIST+=("/usr/include/")
}
fi

#
for ONE_PATH in "${CHK_LIST[@]}"; do
{
    if [ -f "${ONE_PATH}/${HDNAME}" ] || [ -L "${ONE_PATH}/${HDNAME}" ];then
    {
        echo "${ONE_PATH}"
        exit 0
    }
    fi
}
done

#
exit 1