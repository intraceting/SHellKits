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
CROSSTOOL_SAMPLE=$1
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
{
    #如果配置文件不存在则必须输入有效的样本名字.
    if [ "${CROSSTOOL_SAMPLE}" == "" ];then
        exit_if_error 1 "No sample specified." 1
    fi
}
fi

#创建必要但可能不存在路径.
mkdir -p ${CROSSTOOL_HOME}/{build,src,x-tools}

#进入构建路径.
cd ${CROSSTOOL_HOME}/build/

#如果样本名字存在则进入配置,否则跳过.
if [ "${CROSSTOOL_SAMPLE}" != "" ];then
{
    #配置样本参数.
    ${CROSSTOOL_BIN} ${CROSSTOOL_SAMPLE}
    exit_if_error $? "Invalid or unsupported sample name." $?
}
fi


#打开配置页面.
${CROSSTOOL_BIN} menuconfig
exit_if_error $? "Configuration is incomplete or contains errors." $?