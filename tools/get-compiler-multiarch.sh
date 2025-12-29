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

#不为空直接返回.
if [ "${TARGET_MULTIARCH}" != "" ];then
	echo "${TARGET_MULTIARCH}"
	exit 0
fi

#
TARGET_MACHINE=$(${COMPILER_BIN} "-dumpmachine" 2>>/dev/null)
checkReturnCode

#为空直接返回.
if [ "${TARGET_MACHINE}" == "" ];then
	echo "${TARGET_MACHINE}"
	exit 0
fi

#拆分到数组.
IFS='-' read -r -a ARR <<< "$TARGET_MACHINE"
LEN=${#ARR[@]}

#少于三段直接返回, 大于三段则使用0,LEN-2,LEN-1拼接起来.
if [ ${LEN} -lt 3 ];then
	echo "${TARGET_MACHINE}"
else
	echo "${ARR[0]}-${ARR[LEN-2]}-${ARR[LEN-1]}"
fi



