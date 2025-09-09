#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# 
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
fetch_package_info()
# $1 NAME
# $2 FLAG
{
    NAME=$1
    FLAG=$2
    #
    if (( FLAG == 1 ));then
        ${SHELLDIR}/packages/${NAME}.sh "4"
    elif (( FLAG == 2 ));then
        ${SHELLDIR}/packages/${NAME}.sh "2"
    elif (( FLAG == 3 ));then
        ${SHELLDIR}/packages/${NAME}.sh "3"
    fi
}

#
PACKAGE_FLAG=1
PACKAGE_NAME=""
SYSROOT_PATH="/usr/:/usr/local/"
TARGET_MACHINE="$(uname -m)-linux-gnu"

#
PrintUsage()
{
cat << EOF
usage: [ OPTIONS [ VARIABLE ... ] ]

OPTIONS:

    -h 
     打印帮助信息。

    -d < KEY=VALUE | KEY= >
     定义变量及变量赋值。

VARIABLE: 
     
     PACKAGE_FLAG=${PACKAGE_FLAG}

     PACKAGE_FLAG(组件包标志, 用于区分不同的查找对象.)支持以下关键字：
     1: 返回组件包名称.
     2: 返回组件包CFLAGS的值.
     3: 返回组件包LIBS的值.

     PACKAGE_NAME=${PACKAGE_NAME}

     PACKAGE_NAME(组件包名称.)查找对象所属的组件包名称.

     SYSROOT_PATH=${SYSROOT_PATH}

     SYSROOT_PATH(文件系统根路径, 多个路径之间以:分隔.)用于区分不同的文件系统.

     TARGET_MACHINE=${TARGET_MACHINE}

     TARGET_MACHINE(目标操作系统.)用于区分不同的操作系统.

EOF
}

#
while getopts "hd:" ARGKEY 
do
    case $ARGKEY in
    h)
        PrintUsage
        exit 0
    ;;
    d)
        # 使用正则表达式检查参数是否为 "key=value" 或 "key=" 的格式.
        if [[ ${OPTARG} =~ ^[a-zA-Z_][a-zA-Z0-9_]*= ]]; then
            declare "${OPTARG%%=*}"="${OPTARG#*=}"
        else 
            echo "'-d ${OPTARG}' will be ignored, the parameter of '- d' only supports the format of 'key=value' or 'key=' ."
        fi 
    ;;
    esac
done

#
if (( PACKAGE_FLAG < 1 || PACKAGE_FLAG > 3 )); then
    exit_if_error 22 "不支持的组件包标志(${PACKAGE_FLAG})." 22
fi

#
if [ "${PACKAGE_NAME}" == "" ];then
    exit_if_error 22 "组件包名称不能省略或为空." 22
fi

#
if [ "${SYSROOT_PATH}" == "" ];then
    exit_if_error 22 "文件系统根路径不能省略或为空." 22
fi

#
if [ "${TARGET_MACHINE}" == "" ];then
    exit_if_error 22 "组件包名称不能省略或为空." 22
fi

#转换构建平台架构关键字。
TARGET_PLATFORM=$(echo ${TARGET_MACHINE} | cut -d - -f 1)
if [ "${TARGET_PLATFORM}" == "x86_64" ];then
    TARGET_BITWIDE="64"
elif [ "${TARGET_PLATFORM}" == "aarch64" ] || [ "${TARGET_PLATFORM:0:5}" == "armv8l" ];then
    TARGET_BITWIDE="64"
elif [ "${TARGET_PLATFORM}" == "arm" ] || [ "${TARGET_PLATFORM:0:5}" == "armv7" ];then
    TARGET_BITWIDE="32"
else 
    TARGET_BITWIDE="128"
fi
#
if (( TARGET_BITWIDE != 64 && TARGET_BITWIDE != 32 )); then
    exit_if_error 22 "不支持的目标操作系统(${TARGET_BITWIDE})." 22
fi


#拆分到数组中.
IFS=":" read -ra SYSROOT_PATH_VECTOR <<< "${SYSROOT_PATH}"

#从左到右编历查找. 
for ONE_SYSROOT_PATH in "${SYSROOT_PATH_VECTOR[@]}"; do
{
    #设置环境变量, 用于搜索依赖包.
    export _3RDPARTY_PKG_MACHINE=${TARGET_MACHINE}
    export _3RDPARTY_PKG_WORDBIT=${TARGET_BITWIDE}
    export _3RDPARTY_PKG_FIND_ROOT=${ONE_SYSROOT_PATH}
    export _3RDPARTY_PKG_FIND_MODE="only"

    #按标志查找需要的包信息.
    (fetch_package_info ${PACKAGE_NAME} ${PACKAGE_FLAG})
    if (( $? == 0 ));then
        exit 0
    fi
}
done

#
exit 2
