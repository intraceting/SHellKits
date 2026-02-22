#!/bin/bash
#
# This file is part of TOOLCHAIN.
#  
# Copyright (c) 2026 The TOOLCHAIN project authors. All Rights Reserved.
##

#
SHELLDIR=$(cd `dirname "$0"`; pwd)

#
exit_if_error()
#errno
#errstr
#exitcode
{
    if [ $# -ne 3 ];then
    {
        echo "Requires three parameters: errno, errstr, exitcode."
        exit 1
    }
    fi 
    
    if [ $1 -ne 0 ];then
    {
        echo $2
        exit $3
    }
    fi
}

#
CROSSTOOL_BIN=$(which ct-ng)

#
TMP_HOME_A=$(realpath -s "${SHELLDIR}")
TMP_HOME_B=$(realpath -s "${PWD}")

#
if [ "${TMP_HOME_A}" == "${TMP_HOME_B}" ];then
CROSSTOOL_HOME=${PWD}/cross-toolchain/
else 
CROSSTOOL_HOME=${PWD}/
fi

#
if [ ! -f "${CROSSTOOL_BIN}" ] && [ ! -L "${CROSSTOOL_BIN}" ];then
exit_if_error 1 "'crosstool-ng' is not installed or not in the default location." 1
fi

#检查配置文件是否已经存.
if [ ! -f "${CROSSTOOL_HOME}/build/.config" ];then
exit_if_error 1 "Configuration is incomplete or contains errors." 1
fi

#取消存在冲突的环境变量配置.
unset LD_LIBRARY_PATH
#修改环境变量.
export HOME=${CROSSTOOL_HOME}

#进入构建路径.
cd ${CROSSTOOL_HOME}/build/

#开始构建.
${CROSSTOOL_BIN} build
exit_if_error $? "Build incomplete or an error occurred." $?