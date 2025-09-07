#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# Copyright (c) 2025 The ABCDK project authors. All Rights Reserved.
# 
##
#
SHELLDIR=$(cd `dirname $0`; pwd)

# Functions
checkReturnCode()
{
    rc=$?
    if [ $rc != 0 ];then
        exit $rc
    fi
}

#
TARGET_PLATFORM=$(${SHELLDIR}/get-compiler-platform.sh "${1}")
checkReturnCode

#转换构建平台架构关键字。
if [ "${TARGET_PLATFORM}" == "x86_64" ];then
{
    TARGET_ARCH="amd64"
}
elif [ "${TARGET_PLATFORM}" == "aarch64" ] || [ "${TARGET_PLATFORM:0:5}" == "armv8" ];then
{
    TARGET_ARCH="arm64"
}
elif [ "${TARGET_PLATFORM}" == "arm" ] || [ "${TARGET_PLATFORM:0:5}" == "armv7" ];then
{
    TARGET_ARCH="arm"
}
else
{
    exit 127
}
fi

echo "${TARGET_ARCH}"