#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# Copyright (c) 2021 The ABCDK project authors. All Rights Reserved.
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
CheckKeyword()
# $1 keywords
# $2 word
{
    ${SHELLDIR}/../tools/check-keyword.sh "$1" "$2"
}

#
CheckSTD_C()
# $1 COMPILER
# $2 STD
{
    ${SHELLDIR}/../tools/check-c-std.sh "$1" "$2"
}


#
CheckSTD_CXX()
# $1 COMPILER
# $2 STD
{
    ${SHELLDIR}/../tools/check-cxx-std.sh "$1" "$2"
}

#
CheckSTD_NVCC()
# $1 COMPILER
# $2 STD
# $3 CCBIN
{
    ${SHELLDIR}/../tools/check-nvcc-std.sh "$1" "$2" "$3"
}

#
CheckHeader_C()
# $1 COMPILER
# $2 STD
# $3 HEADER
{
    ${SHELLDIR}/../tools/check-c-std-header.sh "$1" "$2" "$3"
}

#
CheckHeader_CXX()
# $1 COMPILER
# $2 STD
# $3 HEADER
{
    ${SHELLDIR}/../tools/check-cxx-std-header.sh "$1" "$2" "$3"
}

#
PrintCompilerConf()
# $1 PREFIX
{
    ${SHELLDIR}/../tools/print-compiler-conf.sh -d SOLUTION_PREFIX=FAST_C_CXX -d TARGET_COMPILER_PREFIX="$1"
}

#
FindPKG_CFLAGS()
#$1 "NAME [NAME ...]"
#$2 "PREFIX[:PREFIX:...]"
#$3 "MACHINE"
{
    ${SHELLDIR}/../tools/pkg-find-cflags.sh "$1" "$2" "$3"
}

#
FindPKG_LDFLAGS()
#$1 "NAME [NAME ...]"
#$2 "PREFIX[:PREFIX:...]"
#$3 "MACHINE"
{
    ${SHELLDIR}/../tools/pkg-find-ldflags.sh "$1" "$2" "$3"
}

#
FindINC_PATH()
#$1 "NAME [NAME ...]"
#$2 "PREFIX[:PREFIX:...]"
#$3 "MACHINE"
{
    ${SHELLDIR}/../tools/find-inc-path.sh "$1" "$2" "$3"
}

#
FindLIB_PATH()
#$1 "NAME [NAME ...]"
#$2 "PREFIX[:PREFIX:...]"
#$3 "MACHINE"
{
    ${SHELLDIR}/../tools/find-lib-path.sh "$1" "$2" "$3"
}


#
FindBIN_PATH()
#$1 "NAME [NAME ...]"
#$2 "PREFIX[:PREFIX:...]"
#$3 "MACHINE"
{
    ${SHELLDIR}/../tools/find-bin-path.sh "$1" "$2" "$3"
}

#默认makefile在上层目录.
SOURCE_PATH=${PWD}/../

#
BUILD_PATH=${PWD}

#
BUILD_TYPE="release"

#
INSTALL_PREFIX="/usr/local/"

#
LSB_RELEASE="linux-gnu"

#
COMPILER_PREFIX=/usr/bin/

#
EXTRA_C_FLAGS=""
EXTRA_CXX_FLAGS=""
EXTRA_LD_FLAGS=""

#
COMPILER_CUDA_BIN=""

#
C_STD="c99"
CXX_STD="c++17"

#


#
THIRDPARTY_PREFIX="/usr:/usr/local"

#
WITH_PACKAGE=""


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

     SOURCE_PATH=${SOURCE_PATH}

     SOURCE_PATH(makefile所在路径)项目(或方案)路径.

     BUILD_PATH=${BUILD_PATH}

     BUILD_PATH(过程文件存放的路径)用于存放构建过程文件.

     BUILD_TYPE=${BUILD_TYPE}
    
     BUILD_TYPE(构建类型)支持以下关键字：
     debug,release

     INSTALL_PREFIX=${INSTALL_PREFIX}

     INSTALL_PREFIX(安装路经的前缀).
    
     LSB_RELEASE=${LSB_RELEASE}

     LSB_RELEASE(发行版名称)支持以下关键字:
     linux-gnu,android
     
     COMPILER_PREFIX=${COMPILER_PREFIX}

     COMPILER_PREFIX(C/C++编译器路径的前缀)与编译器名字组成完整路径.

     EXTRA_C_FLAGS=${EXTRA_C_FLAGS}

     EXTRA_C_FLAGS(C编译器的编译参数)用于编译器的源码编译. 

     EXTRA_CXX_FLAGS=${EXTRA_CXX_FLAGS}

     EXTRA_CXX_FLAGS(C++编译器的编译参数)用于编译器的源码编译. 

     EXTRA_LD_FLAGS=${EXTRA_LD_FLAGS}

     EXTRA_LD_FLAGS(编译器的链接参数)用于编译器的目标链接. 

     COMPILER_CUDA_BIN=${COMPILER_CUDA_BIN}

     COMPILER_CUDA_BIN(CUDA编译器的完整路径).
     
     THIRDPARTY_PREFIX=${THIRDPARTY_PREFIX}

     THIRDPARTY_PREFIX(依赖组件搜索根路径)用于查找依赖组件完整路径.

     WITH_PACKAGE=${WITH_PACKAGE}

     WITH_PACKAGE(依赖组件列表)支持以下关键字:
     lz4,jsonc,jsoncpp,
     libmagic,openssl,curl,
     qrencode,eigen3,fastcgi,libuuid,
     unixodbc,hiredis,sqlite3,
     live555,libarchive,nghttp2,
     ffmpeg,opencv,faiss,onnx,protobuf
     cuda,cudnn,tensorrt,
     qt5
     
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

#必须在项目之外运行此脚本.
if [ "${SHELLDIR}" == "${PWD}" ];then
{
    exit_if_error 1 "This script must be run outside of the project." 1
}
fi

#
COMPILER_CONF=$(PrintCompilerConf ${COMPILER_PREFIX})
exit_if_error $? "${COMPILER_CONF}" $?

#
eval "${COMPILER_CONF}"

#
source ${SHELLDIR}/configure.d/compiler-check.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-c-header.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-odbc.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-sqlite3.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-openssl.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-ffmpeg.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-lz4.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-libarchive.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-hiredis.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-jsonc.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-jsoncpp.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-fastcgi.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-qrencode.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-libuuid.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-libmagic.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-nghttp2.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-curl.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-opencv.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-onnx.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-protobuf.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-live555.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-eigen3.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-faiss.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-cuda.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-cudnn.in.sh
#
source ${SHELLDIR}/configure.d/depend-check-tensorrt.in.sh

#提取第三方依整包的所有路径.
THIRDPARTY_LIB_DIR=$(echo "${EXTRA_LD_FLAGS}" | tr ' ' '\n' | grep "^-L" | sed 's/^-L//' | sort | uniq | tr '\n' ':' | sed 's/:$//')

#保存.
echo "THIRDPARTY_LIB_DIR=${THIRDPARTY_LIB_DIR}" > ${PWD}/3party-lib-dir.in.sh
exit_if_error $? "An error occurred while writing '3party-lib-dir.in.sh'." $?

#
cat >${PWD}/makefile.conf <<EOF
#
BUILD_PATH ?= ${BUILD_PATH}
#
BUILD_TYPE ?= ${BUILD_TYPE}
#
INSTALL_PREFIX ?= ${INSTALL_PREFIX}
#
LSB_RELEASE = ${LSB_RELEASE}
#
TARGET_PLATFORM = ${FAST_C_CXX_TARGET_PLATFORM}
#
C_STD ?= ${C_STD}
CXX_STD ?= ${CXX_STD}
#
CC = ${FAST_C_CXX_TARGET_COMPILER_C}
CXX = ${FAST_C_CXX_TARGET_COMPILER_CXX}
AR = ${FAST_C_CXX_TARGET_COMPILER_AR}
#
NVCC = ${COMPILER_CUDA_BIN}
#
EXTRA_C_FLAGS = ${EXTRA_C_FLAGS}
EXTRA_CXX_FLAGS = ${EXTRA_CXX_FLAGS}
EXTRA_LD_FLAGS = ${EXTRA_LD_FLAGS}
#
EXTRA_RPATH = ${THIRDPARTY_LIB_DIR}
#
SHELLKITS_HOME = $(realpath -m "${SHELLDIR}/../")
#
$(printf "%s\n" "${THIRDPARTY_ENABLE[@]/%/ = yes}")

#
EOF
exit_if_error $? "An error occurred while writing 'makefile.conf'." $?



#
cat > ${PWD}/makefile <<EOF
# SHELLKITS generated file: DO NOT EDIT!
#

#默认的标签必须存在, 否则无参数启动时会无效.
all:

#万能标签匹配, 转发启动参数. ";" 表示此行为空行.
%:: ; \$(MAKE) -C ${SOURCE_PATH}  CONF_FILE=${PWD}/makefile.conf \$@

EOF
exit_if_error $? "An error occurred while writing 'makefile'." $?