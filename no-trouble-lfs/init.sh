#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2026 The SHELLKITS project authors. All Rights Reserved.
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

#外部命令列表.
CMD_CHECK_LIST+=("dirname")
CMD_CHECK_LIST+=("basename")
CMD_CHECK_LIST+=("realpath")
CMD_CHECK_LIST+=("stat")
CMD_CHECK_LIST+=("cat")
CMD_CHECK_LIST+=("readlink")
CMD_CHECK_LIST+=("sha256sum")
CMD_CHECK_LIST+=("awk")
CMD_CHECK_LIST+=("mkdir")
CMD_CHECK_LIST+=("cp")
CMD_CHECK_LIST+=("rm")
CMD_CHECK_LIST+=("7z")

#验证外部命令是否已经安装.
for CHECK_ONE in "${CMD_CHECK_LIST[@]}"; do
{
    which ${CHECK_ONE} >/dev/null 2>&1
    exit_if_error $? "${CHECK_ONE} 未找到或尚未安装." $?
}
done

#
TMP_HOME_A=$(realpath -s "${SHELLDIR}")
TMP_HOME_B=$(realpath -s "${PWD}")

#不允许脚本所在目录运行.
if [ "${TMP_HOME_A}" == "${TMP_HOME_B}" ];then
{
    exit_if_error 1 "Scripts cannot be run from the directory where they are located." 1
}
fi

#
MANIFEST_NAME=".gitignore"
REPOSITORY_NAME=".ntlfs"

#定位最近的文件清单路径.
TOP_PATH=$(${SHELLDIR}/locate.sh "${MANIFEST_NAME}")

#如果未找到则使用当前工作目录.
if [ "${TOP_PATH}" == "" ];then
TOP_PATH="${PWD}"
fi

#
MANIFEST_FILE="${TOP_PATH}/${MANIFEST_NAME}"
REPOSITORY_FILE="${TOP_PATH}/${REPOSITORY_NAME}"

#
MANIFEST_BEGIN_KEY="# ntlfs-manifest-begin"
MANIFEST_END_KEY="# ntlfs-manifest-end"


#按需创建文件清单.
if [ ! -e "${MANIFEST_FILE}" ];then
> "${MANIFEST_FILE}"
fi

#
echo "${MANIFEST_BEGIN_KEY}" >> "${MANIFEST_FILE}"
echo "${MANIFEST_END_KEY}" >> "${MANIFEST_FILE}"

#按需创建仓储路径.
mkdir -p "${REPOSITORY_FILE}"