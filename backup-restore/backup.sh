#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2026 The SHELLKITS project authors. All Rights Reserved.
##
#
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
CMD_CHECK_LIST+=("realpath")
CMD_CHECK_LIST+=("find")

#验证外部命令是否已经安装.
for CHECK_ONE in "${CMD_CHECK_LIST[@]}"; do
{
    which ${CHECK_ONE} >>/dev/null 2>&1
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
if [ "${#}" -ne 2 ]; then
    echo "使用方法: ${0} <源目录> <备份目录>"
    exit 1
fi

# 获取源目录和目标目录的绝对路径
SRC_DIR=$(realpath -s -m "${1}")
DST_DIR=$(realpath -s -m "${2}")

#仅备份符号链接或普通文件.
find "${SRC_DIR}/" -type f,l -exec "${SHELLDIR}/backup-single.sh" "${DST_DIR}" {} "${SRC_DIR}/" \;