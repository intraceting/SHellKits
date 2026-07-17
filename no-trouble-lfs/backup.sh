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

#
TMP_HOME_A=$(realpath -s "${SHELLDIR}")
TMP_HOME_B=$(realpath -s "${PWD}")

#不允许脚本所在目录运行.
if [ "${TMP_HOME_A}" == "${TMP_HOME_B}" ];then
{
    exit_if_error 1 "Scripts cannot be run from the directory where they are located." 1
}
fi

#检查参数.
if [ "${#}" -ne 3 ]; then
    echo "使用方法: ${0} <备份根路径> <原始根路径> <原始文件路径> "
    exit 1
fi

#去掉冗余层, 但不要展开符号链接.
DST_PATH=$(realpath -s -m "${1}")
SRC_PATH=$(realpath -s -m "${2}")
SRC_SUFFIX="${3}"

#拼接原始文件完整路径.
SRC_FILE=$(realpath -s -m "${SRC_PATH}/${SRC_SUFFIX}")

#提取原始文件名.
SRC_NAME="${SRC_FILE##*/}"

#提取原始文件上级路径.
SRC_PERV_PATH="${SRC_FILE%/*}"

#拼接备份文件完整路径.
DST_FILE=$(realpath -s -m "${DST_PATH}/${SRC_SUFFIX}")

#提取备份文件上级路径.
DST_PERV_PATH="${DST_FILE%/*}"

#备份文件指纹文件.
DST_CHKSUM_FILE="${DST_FILE}-ntlfs.checksum.sha256"

#备份文件分卷前缀.
DST_VOLUME_PERFIX="${DST_FILE}/${SRC_NAME}-ntlfs.rawdata"

#备份文件的属性文件.
DST_ATTR_FILE="${DST_FILE}-ntlfs.attribute.txt"


# echo "DST_PATH=${DST_PATH}"
# echo "SRC_SUFFIX=${SRC_SUFFIX}"
# echo "SRC_PATH=${SRC_PATH}"
# echo "SRC_FILE=${SRC_FILE}"
# echo "SRC_NAME=${SRC_NAME}"
# echo "SRC_PERV_PATH=${SRC_PERV_PATH}"
# echo "DST_FILE=${DST_FILE}"
# echo "DST_PERV_PATH=${DST_PERV_PATH}"
# echo "DST_CHKSUM_FILE=${DST_CHKSUM_FILE}"
# echo "DST_VOLUME_PERFIX=${DST_VOLUME_PERFIX}"
# echo "DST_ATTR_FILE=${DST_ATTR_FILE}"
# exit 0

#获取原始权限.
PERM_DATA_NEW=$(stat -c "%a" "${SRC_FILE}" 2>/dev/null)

#读取备份权限.
PERM_DATA_OLD=$(cat "${DST_ATTR_FILE}" 2>/dev/null)

#计算原始指纹.
if [ -f "${SRC_FILE}" ]; then
    CHKSUM_DATA_NEW=$(sha256sum "${SRC_FILE}" | awk "{print \$1}")
else
    exit 1
fi

#读取备份指纹.
CHKSUM_DATA_OLD=$(cat "${DST_CHKSUM_FILE}" 2>/dev/null)

#比较指纹, 判定是否需要重新备份.
if [ "${CHKSUM_DATA_NEW}" == "${CHKSUM_DATA_OLD}" ];then
{
    if [ "${PERM_DATA_NEW}" != "${PERM_DATA_OLD}" ];then
    {
        #备份属性.
        echo "${PERM_DATA_NEW}" > "${DST_ATTR_FILE}" 2>/dev/null
        exit_if_error $? "备份属性失败(空间不足或无权限): '${SRC_SUFFIX}'" $?

        #
        echo "备份属性完成: '${SRC_SUFFIX}'"
    }
    else
    {
        echo "跳过(原始文件无变化): '${SRC_SUFFIX}'"
    }
    fi
}
else
{
    #创建可能不存的路径.
    mkdir -p "${DST_PERV_PATH}"

    #如果目录存在则删除所有旧的备份, 否则创建原始名字同名目录.
    if [ -d "${DST_FILE}" ];then
        rm -f "${DST_VOLUME_PERFIX}"*
    else
        mkdir -p "${DST_FILE}"
    fi

    #备份正文. 分卷备份, 每卷5MB.
    7z a -mx=0 -v5m -y "${DST_VOLUME_PERFIX}" "${SRC_FILE}" >/dev/null 2>&1
    exit_if_error $? "备份正文失败(空间不足或无权限): '${SRC_SUFFIX}'" $?
 
    #备份属性.
    echo "${PERM_DATA_NEW}" > "${DST_ATTR_FILE}"  2>/dev/null
    exit_if_error $? "备份属性失败(空间不足或无权限): '${SRC_SUFFIX}'" $?

    #备份指纹.
    echo "${CHKSUM_DATA_NEW}" > "${DST_CHKSUM_FILE}" 2>/dev/null
    exit_if_error $? "备份指纹失败(空间不足或无权限): '${SRC_SUFFIX}'" $?

    echo "备份完成: '${SRC_SUFFIX}'"
}
fi

#
exit 0
