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
SONAME="$1"

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
if [ "${PKG_MACHINE}" == "" ];then
PKG_MACHINE="$(uname -m)-linux-gnu"
fi 

#
if [ "${PKG_WORDBIT}" == "" ];then
{
    if [ "$(getconf WORD_BIT)" == "32" ] && [ "$(getconf LONG_BIT)" == "64" ];then
        PKG_WORDBIT="64"
    else 
        PKG_WORDBIT="32"
    fi 
}
fi

#
if [ "${PKG_FIND_MODE}" == "only" ];then
{
    CHK_LIST[0]="${PKG_FIND_ROOT}/lib${PKG_WORDBIT}/${PKG_MACHINE}/"
    CHK_LIST[1]="${PKG_FIND_ROOT}/lib${PKG_WORDBIT}/"
    CHK_LIST[2]="${PKG_FIND_ROOT}/lib/${PKG_MACHINE}/"
    CHK_LIST[3]="${PKG_FIND_ROOT}/lib/"
}
elif [ "${PKG_FIND_MODE}" == "both" ];then
{
    CHK_LIST[0]="${PKG_FIND_ROOT}/lib${PKG_WORDBIT}/${PKG_MACHINE}/"
    CHK_LIST[1]="${PKG_FIND_ROOT}/lib${PKG_WORDBIT}/"
    CHK_LIST[2]="${PKG_FIND_ROOT}/lib/${PKG_MACHINE}/"
    CHK_LIST[3]="${PKG_FIND_ROOT}/lib/"
    CHK_LIST[4]="/usr/lib${PKG_WORDBIT}/${PKG_MACHINE}/"
    CHK_LIST[5]="/usr/lib${PKG_WORDBIT}/"
    CHK_LIST[6]="/usr/lib/${PKG_MACHINE}/"
    CHK_LIST[7]="/usr/lib/"
    CHK_LIST[8]="/usr/local/lib${PKG_WORDBIT}/${PKG_MACHINE}/"
    CHK_LIST[9]="/usr/local/lib${PKG_WORDBIT}/"
    CHK_LIST[10]="/usr/local/lib/${PKG_MACHINE}/"
    CHK_LIST[11]="/usr/local/lib/"
}
else
{
    CHK_LIST[0]="/usr/lib${PKG_WORDBIT}/${PKG_MACHINE}/"
    CHK_LIST[1]="/usr/lib${PKG_WORDBIT}/"
    CHK_LIST[2]="/usr/lib/${PKG_MACHINE}/"
    CHK_LIST[3]="/usr/lib/"
    CHK_LIST[4]="/usr/local/lib${PKG_WORDBIT}/${PKG_MACHINE}/"
    CHK_LIST[5]="/usr/local/lib${PKG_WORDBIT}/"
    CHK_LIST[6]="/usr/local/lib/${PKG_MACHINE}/"
    CHK_LIST[7]="/usr/local/lib/"
}
fi

#
for ONE_PATH in "${CHK_LIST[@]}"; do
{
    if [ -f "${ONE_PATH}/${SONAME}" ] || [ -L "${ONE_PATH}/${SONAME}" ] || \
        [ -f "${ONE_PATH}/lib${SONAME}.so" ] || [ -L "${ONE_PATH}/lib${SONAME}.so" ] || \
        [ -f "${ONE_PATH}/lib${SONAME}.a" ] || [ -L "${ONE_PATH}/lib${SONAME}.a" ];then
    {
        echo "${ONE_PATH}"
        exit 0
    }
    fi
}
done

#
exit 1