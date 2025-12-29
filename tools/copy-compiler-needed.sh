#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# 
##
SHELLDIR=$(cd `dirname "$0"`; pwd)

#
if [ $# -ne 2 ];then
    exit 22
fi

#
COMPILER_BIN=$1
TARGET_PATH=$2

#
SYSROOT=$(${SHELLDIR}/get-compiler-sysroot.sh ${COMPILER_BIN})
MULTIARCH=$(${SHELLDIR}/get-compiler-multiarch.sh ${COMPILER_BIN})

if [ -f ${SYSROOT}/lib64/libgcc_s.so.1 ];then
    mkdir -p ${TARGET_PATH}
    cp -fP ${SYSROOT}/lib64/libgcc_s*.so.* ${TARGET_PATH}/
    cp -fP ${SYSROOT}/lib64/libgfortran*.so.* ${TARGET_PATH}/
    cp -fP ${SYSROOT}/lib64/libgomp*.so.* ${TARGET_PATH}/
    cp -fP ${SYSROOT}/lib64/libstdc++*.so.* ${TARGET_PATH}/
    cp -fP ${SYSROOT}/lib64/libatomic*.so.* ${TARGET_PATH}/
elif [ -f ${SYSROOT}/lib/libgcc_s.so.1 ];then
    mkdir -p ${TARGET_PATH}
    cp -fP ${SYSROOT}/lib/libgcc_s*.so.* ${TARGET_PATH}/
    cp -fP ${SYSROOT}/lib/libgfortran*.so.* ${TARGET_PATH}/
    cp -fP ${SYSROOT}/lib/libgomp*.so.* ${TARGET_PATH}/
    cp -fP ${SYSROOT}/lib/libstdc++*.so.* ${TARGET_PATH}/
    cp -fP ${SYSROOT}/lib/libatomic*.so.* ${TARGET_PATH}/
elif [ -f ${SYSROOT}/lib/${MULTIARCH}/libgcc_s.so.1 ];then
    mkdir -p ${TARGET_PATH}
    cp -fP ${SYSROOT}/lib/${MULTIARCH}/libgcc_s*.so.* ${TARGET_PATH}/
    cp -fP ${SYSROOT}/lib/${MULTIARCH}/libgfortran*.so.* ${TARGET_PATH}/
    cp -fP ${SYSROOT}/lib/${MULTIARCH}/libgomp*.so.* ${TARGET_PATH}/
    cp -fP ${SYSROOT}/lib/${MULTIARCH}/libstdc++*.so.* ${TARGET_PATH}/
    cp -fP ${SYSROOT}/lib/${MULTIARCH}/libatomic*.so.* ${TARGET_PATH}/
fi
