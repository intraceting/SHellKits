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
    CHK_LIST+=("${PKG_FIND_ROOT}/lib${PKG_BITWIDE}/")
    CHK_LIST+=("${PKG_FIND_ROOT}/lib/")
}
elif [ "${PKG_FIND_MODE}" == "both" ];then
{
    CHK_LIST+=("${PKG_FIND_ROOT}/lib${PKG_BITWIDE}/")
    CHK_LIST+=("${PKG_FIND_ROOT}/lib/")
    CHK_LIST+=("/usr/local/lib${PKG_BITWIDE}/")
    CHK_LIST+=("/usr/local/lib/")
    CHK_LIST+=("/usr/lib${PKG_BITWIDE}/")
    CHK_LIST+=("/usr/lib/")
    
}
else
{
    CHK_LIST+=("/usr/local/lib${PKG_BITWIDE}/")
    CHK_LIST+=("/usr/local/lib/")
    CHK_LIST+=("/usr/lib${PKG_BITWIDE}/")
    CHK_LIST+=("/usr/lib/")
}
fi

#
for ONE_PATH in "${CHK_LIST[@]}"; do
{
    #
    FIND_NUM=$(find ${ONE_PATH} -maxdepth 2 -xdev -name lib${SONAME}.so -o -name lib${SONAME}.a -o -name ${SONAME} 2>>/dev/null |wc -l)

    #
    if (( FIND_NUM >= 1 ));then
    {
        echo "${ONE_PATH}"
        exit 0
    }
    fi
}
done

#
exit 1