#!/bin/bash
#
# This file is part of ABCDK.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# Copyright (c) 2021 The ABCDK project authors. All Rights Reserved.
##

#
SHELLDIR=$(cd `dirname "$0"`; pwd)


# Functions
checkReturnCode()
{
    rc=$?
    if [ $rc != 0 ];then
        exit $rc
    fi
}


#
CheckPackageKitName()
{
	${SHELLDIR}/../tools/get-kit-name.sh
}

#
CheckKeyword()
# $1 keywords
# $2 word
{
    ${SHELLDIR}/../tools/check-keyword.sh "$1" "$2"
}

#
CheckSTD()
# $1 LANG
# $2 COMPILER
# $3 STD
{
    ${SHELLDIR}/../tools/check-$1-std.sh "$2" "$3"
}


#
CheckHeader()
# $1 LANG
# $2 COMPILER
# $3 STD
# $4 HEADER
{
    ${SHELLDIR}/../tools/check-$1-std-header.sh "$2" "$3" "$4"
}

#
GetCompilerArch()
#$1 BIN
{
    ${SHELLDIR}/../tools/get-compiler-arch.sh "$1" 
}


#
GetCompilerBitWide()
#$1 BIN
{
    ${SHELLDIR}/../tools/get-compiler-bitwide.sh "$1" 
}


#
GetCompilerMachine()
#$1 BIN
{
    ${SHELLDIR}/../tools/get-compiler-machine.sh "$1" 
}

#
GetCompilerPlatform()
#$1 BIN
{
    ${SHELLDIR}/../tools/get-compiler-platform.sh "$1" 
}

#
GetCompilerProgName()
#$1 BIN
#$2 NAME
{
    ${SHELLDIR}/../tools/get-compiler-prog-name.sh "$1" "$2"
}


#
DependCheck()
# $1 PACKAGE_NAME
# $2 PACKAGE_FLAG
# $3 SYSROOT_PATH
# $4 TARGET_BITWIDE
{
    ${SHELLKITS_HOME}/requires/find_package.sh -d PACKAGE_FLAG="$2" -d PACKAGE_NAME="$1" -d SYSROOT_PATH="$3" -d TARGET_BITWIDE="$4"
}

#
DependPackageCheck()
# $1 key
# $2 def
{
    PACKAGE_KEY=$1
    PACKAGE_DEF=$2
    #
    if [ $(CheckKeyword ${THIRDPARTY_PACKAGES} ${PACKAGE_KEY}) -eq 1 ];then
    {
        (DependCheck ${PACKAGE_KEY} 3 ${THIRDPARTY_SYSROOT} ${TARGET_BITWIDE})
        CHK=$?

        if [ ${CHK} -eq 0 ];then
        {
            THIRDPARTY_FLAGS="-D${PACKAGE_DEF} $(DependCheck ${PACKAGE_KEY} 2 ${THIRDPARTY_SYSROOT} ${TARGET_BITWIDE}) ${THIRDPARTY_FLAGS}"
            THIRDPARTY_LINKS="$(DependCheck ${PACKAGE_KEY} 3 ${THIRDPARTY_SYSROOT} ${TARGET_BITWIDE}) ${THIRDPARTY_LINKS}"
            THIRDPARTY_ENABLE+=("${PACKAGE_DEF}")
        }
        else
        {
            THIRDPARTY_NOTFOUND="$(DependCheck ${PACKAGE_KEY} 1 ${THIRDPARTY_SYSROOT} ${TARGET_BITWIDE}) ${THIRDPARTY_NOTFOUND}"
        }
        fi

        echo -n "Check ${PACKAGE_KEY}"
        if [ ${CHK} -eq 0 ];then
            echo -e "\x1b[32m Ok \x1b[0m"
        else 
            echo -e "\x1b[31m Failed \x1b[0m"
        fi
    }
    fi

#    echo ${THIRDPARTY_FLAGS} 
#    echo ${THIRDPARTY_LINKS}
}

#
DependHeaderCheck()
# $1 LANG
# $2 COMPILER
# $3 STD
# $4 HEADER
# $5 DEFINED
{
    CheckHeader $1 "$2" "$3" "$4"
    if [ $? -eq 0 ];then
        THIRDPARTY_FLAGS="-D$5 ${THIRDPARTY_FLAGS}"
    fi

#    echo ${THIRDPARTY_FLAGS} 
}

#主版本
VERSION_MAJOR="0"
#副版本
VERSION_MINOR="0"
#发行版本
VERSION_RELEASE="0"

#
LSB_RELEASE="linux-gnu"

#
INSTALL_PREFIX="/usr/local/"

#
XGETTEXT_BIN=$(which xgettext)
MSGFMT_BIN=$(which msgfmt)
MSGCAT_BIN=$(which msgcat)

#
COMPILER_PREFIX=/usr/bin/
COMPILER_C_NAME=gcc
COMPILER_CXX_NAME=g++

#
COMPILER_C_FLAGS=""
COMPILER_CXX_FLAGS=""
COMPILER_LD_FLAGS=""

#
CUDA_COMPILER_BIN=""

#
BUILD_TYPE="release"

#
OPTIMIZE_LEVEL=""

#
THIRDPARTY_PACKAGES=""
THIRDPARTY_SYSROOT="/usr/:/usr/local/"
THIRDPARTY_NOTFOUND=""
THIRDPARTY_ENABLE="HAVE_SHELLKITS"

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

     BUILD_PATH=${BUILD_PATH}

     BUILD_PATH(过程文件存放的路径)用于存放构建过程文件.

     INSTALL_PREFIX=${INSTALL_PREFIX}

     INSTALL_PREFIX(安装路经的前缀).
    
     VERSION_MAJOR=${VERSION_MAJOR}

     VERSION_MAJOR=(主版本)
     
     VERSION_MINOR=${VERSION_MINOR}

     VERSION_MINOR=(副版本)
     
     VERSION_RELEASE=${VERSION_RELEASE}

     VERSION_RELEASE=(发行版本)

     LSB_RELEASE=${LSB_RELEASE}

     LSB_RELEASE(发行版名称)支持以下关键字:
     linux-gnu,android

     OPTIMIZE_LEVEL=${OPTIMIZE_LEVEL}

     OPTIMIZE_LEVEL(优化级别)支持以下关键字：
     1,2,3,s,fast

     BUILD_TYPE=${BUILD_TYPE}
    
     BUILD_TYPE(构建类型)支持以下关键字：
     debug,release
     
     COMPILER_PREFIX=${COMPILER_PREFIX}

     COMPILER_PREFIX(C/C++编译器路径的前缀)与编译器名字组成完整路径.

     COMPILER_C_NAME=${COMPILER_C_NAME}

     COMPILER_C_NAME(C编译器的名字)与编译器前缀组成完整路径.

     COMPILER_CXX_NAME=${COMPILER_CXX_NAME}

     COMPILER_CXX_NAME(C++编译器的名字)与编译器前缀组成完整路径.

     COMPILER_C_FLAGS=${COMPILER_C_FLAGS}

     COMPILER_C_FLAGS(C编译器的编译参数)用于编译器的源码编译. 

     COMPILER_CXX_FLAGS=${COMPILER_CXX_FLAGS}

     COMPILER_CXX_FLAGS(C++编译器的编译参数)用于编译器的源码编译. 

     COMPILER_LD_FLAGS=${COMPILER_LD_FLAGS}

     COMPILER_LD_FLAGS(编译器的链接参数)用于编译器的目标链接. 

     CUDA_COMPILER_BIN=${CUDA_COMPILER_BIN}

     CUDA_COMPILER_BIN(CUDA编译器的完整路径).

     THIRDPARTY_PACKAGES=${THIRDPARTY_PACKAGES}

     THIRDPARTY_PACKAGES(依赖组件列表)支持以下关键字:
     ffmpeg,json-c,lz4,cuda,cudnn,ffnvcodec,
     unixodbc,opencv,openssl,redis,sqlite,curl,
     archive,nghttp2,libmagic,gtk,appindicator,
     tensorrt,live555,onnxruntime,x264,x265,
     qrencode,zlib,freeimage,fuse,libnm,
     openmp,modbus,libusb,mqtt,eigen,
     bluez,blkid,libcap,fastcgi,systemd,
     libudev,dmtx,zbar,magickwand,
     kafka,uuid,libdrm,
     pam,ncurses,fltk,faiss
     
     THIRDPARTY_SYSROOT=\${INSTALL_PREFIX}

     THIRDPARTY_SYSROOT(依赖组件搜索根路径)用于查找依赖组件完整路径.

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
TARGET_COMPILER_C=$(realpath -s ${COMPILER_PREFIX}${COMPILER_C_NAME})
TARGET_COMPILER_CXX=$(realpath -s ${COMPILER_PREFIX}${COMPILER_CXX_NAME})

#
CheckSTD c "${TARGET_COMPILER_C}" "c99"
if [ $? -ne 0 ];then
{
    echo "The compiler supports at least the c99 standard."
    exit 22
}
fi

#
CheckSTD cxx "${TARGET_COMPILER_CXX}" "c++11"
if [ $? -ne 0 ];then
{
    echo "The compiler supports at least the c++11 standard."
    exit 22
}
fi

#
TARGET_COMPILER_AR=$(GetCompilerProgName "${TARGET_COMPILER_C}" "ar")
TARGET_MACHINE=$(GetCompilerMachine "${TARGET_COMPILER_C}" )
TARGET_PLATFORM=$(GetCompilerPlatform "${TARGET_COMPILER_C}")
TARGET_ARCH=$(GetCompilerArch "${TARGET_COMPILER_C}")
TARGET_BITWIDE=$(GetCompilerBitWide "${TARGET_COMPILER_C}")


#如果未指定第三方根路径，则直接用安装路径。
if [ "${THIRDPARTY_SYSROOT}" == "" ];then
    THIRDPARTY_SYSROOT=${INSTALL_PREFIX}
fi

#
DependHeaderCheck c "${TARGET_COMPILER_C}" c99 "libintl.h" HAVE_LIBINTL_H
DependHeaderCheck c "${TARGET_COMPILER_C}" c99 "pthread.h" HAVE_PTHREAD_H
DependHeaderCheck c "${TARGET_COMPILER_C}" c99 "iconv.h" HAVE_ICONV_H
DependHeaderCheck c "${TARGET_COMPILER_C}" c99 "linux/gpio.h" HAVE_GPIO_H

#
DependPackageCheck openmp HAVE_OPENMP
DependPackageCheck unixodbc HAVE_UNIXODBC
DependPackageCheck sqlite HAVE_SQLITE
DependPackageCheck openssl HAVE_OPENSSL
DependPackageCheck ffmpeg HAVE_FFMPEG
DependPackageCheck freeimage HAVE_FREEIMAGE
DependPackageCheck fuse HAVE_FUSE
DependPackageCheck libnm HAVE_LIBNM
DependPackageCheck lz4 HAVE_LZ4
DependPackageCheck zlib HAVE_ZLIB
DependPackageCheck archive HAVE_ARCHIVE
DependPackageCheck modbus HAVE_MODBUS
DependPackageCheck libusb HAVE_LIBUSB
DependPackageCheck mqtt HAVE_MQTT
DependPackageCheck redis HAVE_REDIS
DependPackageCheck json-c HAVE_JSON_C
DependPackageCheck bluez HAVE_BLUEZ
DependPackageCheck blkid HAVE_BLKID
DependPackageCheck libcap HAVE_LIBCAP
DependPackageCheck fastcgi HAVE_FASTCGI
DependPackageCheck samba HAVE_SAMBA
DependPackageCheck systemd HAVE_SYSTEMD
DependPackageCheck libudev HAVE_LIBUDEV
DependPackageCheck dmtx HAVE_LIBDMTX
DependPackageCheck qrencode HAVE_QRENCODE
DependPackageCheck zbar HAVE_ZBAR
DependPackageCheck magickwand HAVE_MAGICKWAND
DependPackageCheck kafka HAVE_KAFKA
DependPackageCheck uuid HAVE_UUID
DependPackageCheck libmagic HAVE_LIBMAGIC
DependPackageCheck nghttp2 HAVE_NGHTTP2
DependPackageCheck libdrm HAVE_LIBDRM
DependPackageCheck pam HAVE_PAM
DependPackageCheck curl HAVE_CURL
DependPackageCheck ncurses HAVE_NCURSES
DependPackageCheck fltk HAVE_FLTK
DependPackageCheck gtk HAVE_GTK
DependPackageCheck appindicator HAVE_APPINDICATOR
DependPackageCheck x264 HAVE_H264
DependPackageCheck x265 HAVE_H265
DependPackageCheck ffnvcodec HAVE_FFNVCODEC
DependPackageCheck opencv HAVE_OPENCV
DependPackageCheck live555 HAVE_LIVE555
DependPackageCheck onnxruntime HAVE_ONNXRUNTIME
DependPackageCheck eigen HAVE_EIGEN
DependPackageCheck faiss HAVE_FAISS
DependPackageCheck cuda HAVE_CUDA
DependPackageCheck cudnn HAVE_CUDNN
DependPackageCheck tensorrt HAVE_TENSORRT

#
if [ "${CUDA_COMPILER_BIN}" != "" ];then
{
    if [ -f "${CUDA_COMPILER_BIN}" ] || [ -L "${CUDA_COMPILER_BIN}" ];then
    {
        echo "Warning: '${CUDA_COMPILER_BIN}' does not exist. "
    }
    fi
}
fi

#
if [ "${THIRDPARTY_NOTFOUND}" != "" ];then
{
    echo -e "\x1b[33m${THIRDPARTY_NOTFOUND}\x1b[31m not found. \x1b[0m"
    exit 22
}
fi

#提取第三方依整包的所有路径。
THIRDPARTY_LIBS_PATH=$(echo "${THIRDPARTY_LINKS}" | tr ' ' '\n' | grep "^-L" | sed 's/^-L//' | sort | uniq | tr '\n' ':' | sed 's/:$//')

#
mkdir -p ${BUILD_PATH}

#
MKFILE_CONF_FILE=${BUILD_PATH}/makefile.conf

#
cat >${MKFILE_CONF_FILE} <<EOF
#
BUILD_PATH ?= ${BUILD_PATH}
#
INSTALL_PREFIX = ${INSTALL_PREFIX}
#
VERSION_MAJOR = ${VERSION_MAJOR}
VERSION_MINOR = ${VERSION_MINOR}
VERSION_RELEASE = ${VERSION_RELEASE}
#
LSB_RELEASE = ${LSB_RELEASE}
#
XGETTEXT = ${XGETTEXT_BIN}
MSGFMT = ${MSGFMT_BIN}
MSGCAT = ${MSGCAT_BIN}
#
CC = ${TARGET_COMPILER_C}
CXX = ${TARGET_COMPILER_CXX}
AR = ${TARGET_COMPILER_AR}
#
NVCC = ${CUDA_COMPILER_BIN}
#
EXTRA_C_FLAGS = ${COMPILER_C_FLAGS}
EXTRA_CXX_FLAGS = ${COMPILER_CXX_FLAGS}
EXTRA_LD_FLAGS = ${COMPILER_LD_FLAGS}
#
BUILD_TYPE = ${BUILD_TYPE}
#
OPTIMIZE_LEVEL = ${OPTIMIZE_LEVEL}
#
TARGET_PLATFORM = ${TARGET_PLATFORM}
TARGET_ARCH = ${TARGET_ARCH}
TARGET_BITWIDE = ${TARGET_BITWIDE}
#
DEPEND_FLAGS = ${THIRDPARTY_FLAGS}
DEPEND_LINKS = ${THIRDPARTY_LINKS}
#
DEPEND_LIB_PATH = ${THIRDPARTY_LIBS_PATH}
#
SHELL_TOOLS_HOME = $(realpath -s ${SHELLDIR}/../tools/)
#
$(printf "%s\n" "${THIRDPARTY_ENABLE[@]/%/ = yes}")
#
EOF
checkReturnCode


