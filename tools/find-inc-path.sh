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
PKG_MACHINE=${_3RDPARTY_PKG_MACHINE}
PKG_WORDBIT=${_3RDPARTY_PKG_WORDBIT}
PKG_FIND_ROOT=${_3RDPARTY_PKG_FIND_ROOT}
PKG_FIND_MODE=${_3RDPARTY_PKG_FIND_MODE}

#修复默认值。
if [ "${PKG_FIND_MODE}" == "" ];then
PKG_FIND_MODE="default"
fi

#
if [ "${PKG_FIND_MODE}" == "only" ];then
{
    CHK_LIST[0]="${PKG_FIND_ROOT}/include/"
    CHK_LIST[1]="${PKG_FIND_ROOT}/inc/"
    CHK_LIST[2]="${PKG_FIND_ROOT}/"
    
}
elif [ "${PKG_FIND_MODE}" == "both" ];then
{
    CHK_LIST[0]="${PKG_FIND_ROOT}/include/"
    CHK_LIST[1]="${PKG_FIND_ROOT}/inc/"
    CHK_LIST[2]="${PKG_FIND_ROOT}/"
    CHK_LIST[3]="/usr/include/"
    CHK_LIST[4]="/usr/"
    CHK_LIST[5]="/usr/local/include/"
    CHK_LIST[6]="/usr/local/"
}
else
{
    CHK_LIST[0]="/usr/include/"
    CHK_LIST[1]="/usr/"
    CHK_LIST[2]="/usr/local/include/"
    CHK_LIST[3]="/usr/local/"
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