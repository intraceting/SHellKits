#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
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
GetOSId()
{
    ${SHELLDIR}/../tools/get-os-id.sh
}

#
GetKitName()
{
	${SHELLDIR}/../tools/get-kit-name.sh
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
GetCompilerArch()
#$1 BIN
{
    ${SHELLDIR}/../tools/get-compiler-arch.sh "$1" 
}


#
GetCompilerBitWide()
#$1 BIN
{
    ${SHELLDIR}/tools/get-compiler-bitwide.sh "$1" 
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
GetCompilerVersion()
#$1 BIN
{
    ${SHELLDIR}/../tools/get-compiler-version.sh "$1"
}

#
GetCompilerSysroot()
#$1 BIN
{
    ${SHELLDIR}/../tools/get-compiler-sysroot.sh "$1"
}

#
GetLibcVersion()
#$1 BIN
{
    ${SHELLDIR}/../tools/get-compiler-glibc-version.sh "$1" "$2"
}

#
SOLUTION_PREFIX="_"

#
NATIVE_COMPILER_PREFIX=/usr/bin/
NATIVE_COMPILER_C=
NATIVE_COMPILER_CXX=
NATIVE_COMPILER_FORTRAN=
NATIVE_COMPILER_SYSROOT=
NATIVE_COMPILER_AR=
NATIVE_COMPILER_LD=
NATIVE_COMPILER_RANLIB=
NATIVE_COMPILER_READELF=
#
NATIVE_CMAKE_BIN=$(which cmake)

#
TARGET_COMPILER_PREFIX=/usr/bin/
TARGET_COMPILER_C=
TARGET_COMPILER_CXX=
TARGET_COMPILER_FORTRAN=
TARGET_COMPILER_SYSROOT=
TARGET_COMPILER_AR=
TARGET_COMPILER_LD=
TARGET_COMPILER_RANLIB=
TARGET_COMPILER_READELF=


#
PrintUsage()
{
cat << EOF
usage: [ OPTIONS ]
    -h
    打印此文档。

    -d < name=value >
     自定义环境变量。

     SOLUTION_PREFIX=${SOLUTION_PREFIX}

     NATIVE_COMPILER_PREFIX=${NATIVE_COMPILER_PREFIX}
     NATIVE_COMPILER_C=${NATIVE_COMPILER_C}
     NATIVE_COMPILER_CXX=${NATIVE_COMPILER_CXX}
     NATIVE_COMPILER_FORTRAN=${NATIVE_COMPILER_FORTRAN}
     NATIVE_COMPILER_SYSROOT=${NATIVE_COMPILER_SYSROOT}
     NATIVE_COMPILER_AR=${NATIVE_COMPILER_AR}
     NATIVE_COMPILER_LD=${NATIVE_COMPILER_LD}
     NATIVE_COMPILER_RANLIB=${NATIVE_COMPILER_RANLIB}
     NATIVE_COMPILER_READELF=${NATIVE_COMPILER_READELF}

     NATIVE_CMAKE_BIN=${NATIVE_CMAKE_BIN}

     TARGET_COMPILER_PREFIX=${TARGET_COMPILER_PREFIX}
     TARGET_COMPILER_C=${TARGET_COMPILER_C}
     TARGET_COMPILER_CXX=${TARGET_COMPILER_CXX}
     TARGET_COMPILER_FORTRAN=${TARGET_COMPILER_FORTRAN}
     TARGET_COMPILER_SYSROOT=${TARGET_COMPILER_SYSROOT}
     TARGET_COMPILER_AR=${TARGET_COMPILER_AR}
     TARGET_COMPILER_LD=${TARGET_COMPILER_LD}
     TARGET_COMPILER_RANLIB=${TARGET_COMPILER_RANLIB}
     TARGET_COMPILER_READELF=${TARGET_COMPILER_READELF}
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
NATIVE_OSID=$(GetOSId)
if [ "${NATIVE_OSID}" == "" ];then
echo "NATIVE_OSID=${NATIVE_OSID} 无效或不存在."
exit 22
fi

#检查参数。
if [ "${NATIVE_COMPILER_PREFIX}" == "" ];then
echo "NATIVE_COMPILER_PREFIX=${NATIVE_COMPILER_PREFIX} 无效或不存在."
exit 22
fi

#修复默认值。
if [ "${NATIVE_COMPILER_C}" == "" ];then
NATIVE_COMPILER_C="${NATIVE_COMPILER_PREFIX}gcc"
fi
#修复默认值。
if [ "${NATIVE_COMPILER_CXX}" == "" ];then
NATIVE_COMPILER_CXX="${NATIVE_COMPILER_PREFIX}g++"
fi
#修复默认值。
if [ "${NATIVE_COMPILER_FORTRAN}" == "" ];then
NATIVE_COMPILER_FORTRAN="${NATIVE_COMPILER_PREFIX}gfortran"
fi
#修复默认值。
if [ "${NATIVE_COMPILER_SYSROOT}" == "" ];then
NATIVE_COMPILER_SYSROOT=$(GetCompilerSysroot ${NATIVE_COMPILER_C})
fi
#修复默认值。
if [ "${NATIVE_COMPILER_AR}" == "" ];then
NATIVE_COMPILER_AR=$(GetCompilerProgName ${NATIVE_COMPILER_C} "ar")
NATIVE_COMPILER_AR=$(which "${NATIVE_COMPILER_AR}")
fi
#修复默认值。
if [ "${NATIVE_COMPILER_LD}" == "" ];then
NATIVE_COMPILER_LD=$(GetCompilerProgName ${NATIVE_COMPILER_C} "ld")
NATIVE_COMPILER_LD=$(which "${NATIVE_COMPILER_LD}")
fi
#修复默认值。
if [ "${NATIVE_COMPILER_RANLIB}" == "" ];then
NATIVE_COMPILER_RANLIB=$(GetCompilerProgName ${NATIVE_COMPILER_C} "ranlib")
NATIVE_COMPILER_RANLIB=$(which "${NATIVE_COMPILER_RANLIB}")
fi
#修复默认值。
if [ "${NATIVE_COMPILER_READELF}" == "" ];then
NATIVE_COMPILER_READELF=$(GetCompilerProgName ${NATIVE_COMPILER_C} "readelf")
NATIVE_COMPILER_READELF=$(which "${NATIVE_COMPILER_READELF}")
fi

#检查参数。
if [ ! -f "${NATIVE_COMPILER_C}" ];then
echo "NATIVE_COMPILER_C=${NATIVE_COMPILER_C} 无效或不存在."
exit 22
fi
#检查参数。
if [ ! -f "${NATIVE_COMPILER_CXX}" ];then
echo "NATIVE_COMPILER_CXX=${NATIVE_COMPILER_CXX} 无效或不存在."
exit 22
fi
#检查参数。
if [ ! -f "${NATIVE_COMPILER_FORTRAN}" ];then
echo "NATIVE_COMPILER_FORTRAN=${NATIVE_COMPILER_FORTRAN} 无效或不存在."
exit 22
fi
#检查参数。
if [ ! -f "${NATIVE_COMPILER_AR}" ];then
echo "NATIVE_COMPILER_AR=${NATIVE_COMPILER_AR} 无效或不存在."
exit 22
fi
#检查参数。
if [ ! -f "${NATIVE_COMPILER_LD}" ];then
echo "NATIVE_COMPILER_LD=${NATIVE_COMPILER_LD} 无效或不存在."
exit 22
fi
#检查参数。
if [ ! -f "${NATIVE_COMPILER_RANLIB}" ];then
echo "NATIVE_COMPILER_RANLIB=${NATIVE_COMPILER_RANLIB} 无效或不存在."
exit 22
fi
#检查参数。
if [ ! -f "${NATIVE_COMPILER_READELF}" ];then
echo "NATIVE_COMPILER_READELF=${NATIVE_COMPILER_READELF} 无效或不存在."
exit 22
fi


#检查参数。
if [ ! -f "${NATIVE_CMAKE_BIN}" ];then
echo "NATIVE_CMAKE_BIN=${NATIVE_CMAKE_BIN} 无效或不存在."
exit 22
fi


#################################################################################

#检查参数。
if [ "${TARGET_COMPILER_PREFIX}" == "" ];then
echo "TARGET_COMPILER_PREFIX=${TARGET_COMPILER_PREFIX} 无效或不存在."
exit 22
fi

#修复默认值。
if [ "${TARGET_COMPILER_C}" == "" ];then
TARGET_COMPILER_C="${TARGET_COMPILER_PREFIX}gcc"
fi
#修复默认值。
if [ "${TARGET_COMPILER_CXX}" == "" ];then
TARGET_COMPILER_CXX="${TARGET_COMPILER_PREFIX}g++"
fi
#修复默认值。
if [ "${TARGET_COMPILER_FORTRAN}" == "" ];then
TARGET_COMPILER_FORTRAN="${TARGET_COMPILER_PREFIX}gfortran"
fi
#修复默认值。
if [ "${TARGET_COMPILER_SYSROOT}" == "" ];then
TARGET_COMPILER_SYSROOT=$(GetCompilerSysroot ${TARGET_COMPILER_C})
fi
#修复默认值。
if [ "${TARGET_COMPILER_AR}" == "" ];then
TARGET_COMPILER_AR=$(GetCompilerProgName ${TARGET_COMPILER_C} "ar")
TARGET_COMPILER_AR=$(which "${TARGET_COMPILER_AR}")
fi
#修复默认值。
if [ "${TARGET_COMPILER_LD}" == "" ];then
TARGET_COMPILER_LD=$(GetCompilerProgName ${TARGET_COMPILER_C} "ld")
TARGET_COMPILER_LD=$(which "${TARGET_COMPILER_LD}")
fi
#修复默认值。
if [ "${TARGET_COMPILER_RANLIB}" == "" ];then
TARGET_COMPILER_RANLIB=$(GetCompilerProgName ${TARGET_COMPILER_C} "ranlib")
TARGET_COMPILER_RANLIB=$(which "${TARGET_COMPILER_RANLIB}")
fi
#修复默认值。
if [ "${TARGET_COMPILER_READELF}" == "" ];then
TARGET_COMPILER_READELF=$(GetCompilerProgName ${TARGET_COMPILER_C} "readelf")
TARGET_COMPILER_READELF=$(which "${TARGET_COMPILER_READELF}")
fi

#检查参数。
if [ ! -f "${TARGET_COMPILER_C}" ];then
echo "TARGET_COMPILER_C=${TARGET_COMPILER_C} 无效或不存在."
exit 22
fi
#检查参数。
if [ ! -f "${TARGET_COMPILER_CXX}" ];then
echo "TARGET_COMPILER_CXX=${TARGET_COMPILER_CXX} 无效或不存在."
exit 22
fi
#检查参数。
if [ ! -f "${TARGET_COMPILER_FORTRAN}" ];then
echo "TARGET_COMPILER_FORTRAN=${TARGET_COMPILER_FORTRAN} 无效或不存在."
exit 22
fi
#检查参数。
if [ ! -f "${TARGET_COMPILER_AR}" ];then
echo "TARGET_COMPILER_AR=${TARGET_COMPILER_AR} 无效或不存在."
exit 22
fi
#检查参数。
if [ ! -f "${TARGET_COMPILER_LD}" ];then
echo "TARGET_COMPILER_LD=${TARGET_COMPILER_LD} 无效或不存在."
exit 22
fi
#检查参数。
if [ ! -f "${TARGET_COMPILER_RANLIB}" ];then
echo "TARGET_COMPILER_RANLIB=${TARGET_COMPILER_RANLIB} 无效或不存在."
exit 22
fi
#检查参数。
if [ ! -f "${TARGET_COMPILER_READELF}" ];then
echo "TARGET_COMPILER_READELF=${TARGET_COMPILER_READELF} 无效或不存在."
exit 22
fi

#
NATIVE_MACHINE=$(GetCompilerMachine ${NATIVE_COMPILER_C})
TARGET_MACHINE=$(GetCompilerMachine ${TARGET_COMPILER_C})

#
NATIVE_PLATFORM=$(GetCompilerPlatform ${NATIVE_COMPILER_C})
TARGET_PLATFORM=$(GetCompilerPlatform ${TARGET_COMPILER_C})

#转换构建平台架构关键字。
if [ "${NATIVE_PLATFORM}" == "x86_64" ];then
{
    NATIVE_ARCH="amd64"
    NATIVE_BITWIDE="64"
}
elif [ "${NATIVE_PLATFORM}" == "aarch64" ] || [ "${NATIVE_PLATFORM}" == "armv8" ];then
{
    NATIVE_ARCH="arm64"
    NATIVE_BITWIDE="64"
}
elif [ "${NATIVE_PLATFORM}" == "arm" ] || [ "${NATIVE_PLATFORM}" == "armv7" ];then
{
    NATIVE_ARCH="arm"
    NATIVE_BITWIDE="32"
}
fi

#转换构建平台架构关键字。
if [ "${TARGET_PLATFORM}" == "x86_64" ];then
{
    TARGET_ARCH="amd64"
    TARGET_BITWIDE="64"
}
elif [ "${TARGET_PLATFORM}" == "aarch64" ] || [ "${TARGET_PLATFORM}" == "armv8" ];then
{
    TARGET_ARCH="arm64"
    TARGET_BITWIDE="64"
}
elif [ "${TARGET_PLATFORM}" == "arm" ] || [ "${TARGET_PLATFORM}" == "armv7" ];then
{
    TARGET_ARCH="arm"
    TARGET_BITWIDE="32"
}
fi

#
NATIVE_COMPILER_VERSION=$(GetCompilerVersion ${NATIVE_COMPILER_C})
TARGET_COMPILER_VERSION=$(GetCompilerVersion ${TARGET_COMPILER_C})

#提取本机平台的glibc最大版本。
NATIVE_GLIBC_MAX_VERSION=$(GetLibcVersion ${NATIVE_COMPILER_C} ${NATIVE_COMPILER_C})

#提取目标平台的glibc最大版本。
TARGET_GLIBC_MAX_VERSION=$(GetLibcVersion ${NATIVE_COMPILER_C} ${TARGET_COMPILER_C})

#
if [ "${NATIVE_GLIBC_MAX_VERSION}" == "" ];then
echo "无法获取本机平台的glibc版本."
exit 1
fi

#
if [ "${TARGET_GLIBC_MAX_VERSION}" == "" ];then
echo "无法获取目标平台的glibc版本."
exit 1
fi

#下面输出的本文不能包括注释, 因为eval执令可能不支持注释.
cat <<EOF
${SOLUTION_PREFIX}_NATIVE_COMPILER_PREFIX=${NATIVE_COMPILER_PREFIX}
${SOLUTION_PREFIX}_NATIVE_COMPILER_C=${NATIVE_COMPILER_C}
${SOLUTION_PREFIX}_NATIVE_COMPILER_CXX=${NATIVE_COMPILER_CXX}
${SOLUTION_PREFIX}_NATIVE_COMPILER_FORTRAN=${NATIVE_COMPILER_FORTRAN}
${SOLUTION_PREFIX}_NATIVE_COMPILER_SYSROOT=${NATIVE_COMPILER_SYSROOT}
${SOLUTION_PREFIX}_NATIVE_COMPILER_AR=${NATIVE_COMPILER_AR}
${SOLUTION_PREFIX}_NATIVE_COMPILER_LD=${NATIVE_COMPILER_LD}
${SOLUTION_PREFIX}_NATIVE_COMPILER_RANLIB=${NATIVE_COMPILER_RANLIB}
${SOLUTION_PREFIX}_NATIVE_COMPILER_READELF=${NATIVE_COMPILER_READELF}
${SOLUTION_PREFIX}_NATIVE_CMAKE_BIN=${NATIVE_CMAKE_BIN}
${SOLUTION_PREFIX}_TARGET_COMPILER_PREFIX=${TARGET_COMPILER_PREFIX}
${SOLUTION_PREFIX}_TARGET_COMPILER_C=${TARGET_COMPILER_C}
${SOLUTION_PREFIX}_TARGET_COMPILER_CXX=${TARGET_COMPILER_CXX}
${SOLUTION_PREFIX}_TARGET_COMPILER_FORTRAN=${TARGET_COMPILER_FORTRAN}
${SOLUTION_PREFIX}_TARGET_COMPILER_SYSROOT=${TARGET_COMPILER_SYSROOT}
${SOLUTION_PREFIX}_TARGET_COMPILER_AR=${TARGET_COMPILER_AR}
${SOLUTION_PREFIX}_TARGET_COMPILER_LD=${TARGET_COMPILER_LD}
${SOLUTION_PREFIX}_TARGET_COMPILER_RANLIB=${TARGET_COMPILER_RANLIB}
${SOLUTION_PREFIX}_TARGET_COMPILER_READELF=${TARGET_COMPILER_READELF}
${SOLUTION_PREFIX}_NATIVE_MACHINE=${NATIVE_MACHINE}
${SOLUTION_PREFIX}_TARGET_MACHINE=${TARGET_MACHINE}
${SOLUTION_PREFIX}_NATIVE_PLATFORM=${NATIVE_PLATFORM}
${SOLUTION_PREFIX}_TARGET_PLATFORM=${TARGET_PLATFORM}
${SOLUTION_PREFIX}_NATIVE_ARCH=${NATIVE_ARCH}
${SOLUTION_PREFIX}_TARGET_ARCH=${TARGET_ARCH}
${SOLUTION_PREFIX}_NATIVE_BITWIDE=${NATIVE_BITWIDE}
${SOLUTION_PREFIX}_TARGET_BITWIDE=${TARGET_BITWIDE}
${SOLUTION_PREFIX}_NATIVE_COMPILER_VERSION=${NATIVE_COMPILER_VERSION}
${SOLUTION_PREFIX}_TARGET_COMPILER_VERSION=${TARGET_COMPILER_VERSION}
${SOLUTION_PREFIX}_NATIVE_GLIBC_MAX_VERSION=${NATIVE_GLIBC_MAX_VERSION}
${SOLUTION_PREFIX}_TARGET_GLIBC_MAX_VERSION=${TARGET_GLIBC_MAX_VERSION}
EOF
exit_if_error $? "Failed to generate configuration file." $?

