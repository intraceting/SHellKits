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

#转换成绝对路径。
COMPILER_BIN=$(which "${1}")

#
TARGET_MULTIARCH=$(${COMPILER_BIN} "-print-multiarch" 2>>/dev/null)
checkReturnCode

#
echo "${TARGET_MULTIARCH}"
