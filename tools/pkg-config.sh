#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# Copyright (c) 2025 The ABCDK project authors. All Rights Reserved.
##

#
SHELLDIR=$(cd `dirname $0`; pwd)

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
if [ -d ${PKG_FIND_ROOT}/lib${PKG_BITWIDE} ] || [ -L ${PKG_FIND_ROOT}/lib${PKG_BITWIDE} ];then
    PKG_CFG_PATH=$(find ${PKG_FIND_ROOT}/lib${PKG_BITWIDE} -maxdepth 2 -xdev -name "pkgconfig" -printf "%p:" 2>>/dev/null)
fi

#
PKG_CFG_PATH=${PKG_CFG_PATH}:$(find ${PKG_FIND_ROOT}/lib -maxdepth 2 -xdev -name "pkgconfig" -printf "%p:" 2>>/dev/null)
PKG_CFG_PATH=${PKG_CFG_PATH}:$(find ${PKG_FIND_ROOT}/share -maxdepth 2 -xdev -name "pkgconfig" -printf "%p:" 2>>/dev/null)

#
if [ "${PKG_FIND_MODE}" == "only" ];then
export PKG_CONFIG_LIBDIR=${PKG_CFG_PATH}
elif [ "${PKG_FIND_MODE}" == "both" ];then
export PKG_CONFIG_PATH=${PKG_CFG_PATH}
fi

#
pkg-config $@ 2>>/dev/null

