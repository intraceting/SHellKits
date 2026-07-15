#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2026 The SHELLKITS project authors. All Rights Reserved.
##
#
#
SHELLDIR=$(cd `dirname "$0"`; pwd)

#检查参数.
if [ "${#}" -ne 3 ]; then
    echo "使用方法: ${0} <备份目录>  <源文件> <源前缀>"
    exit 1
fi

#
DST_PATH=$(realpath -m "${1}")
SRC_FILE=$(realpath -m "${2}")
SRC_PERFIX=$(realpath -m "${3}")

#提取源文件名.
SRC_NAME="${SRC_FILE##*/}"
#提取源文件相对路径,并接到备份目录后面.
DST_FILE="${DST_PATH}/${SRC_FILE#${SRC_PERFIX}}"
#提取备份文件上级路径.
DST_PERV_PATH="${DST_FILE%/*}"

#较验码文件名.
DST_CHKSUM_FILE="${DST_FILE}-checksum.sha256"

#
# echo "DST_PATH=${DST_PATH}"
# echo "SRC_FILE=${SRC_FILE}"
# echo "SRC_PERFIX=${SRC_PERFIX}"
# echo "SRC_NAME=${SRC_NAME}"
# echo "DST_FILE=${DST_FILE}"
# echo "DST_PERV_PATH=${DST_PERV_PATH}"
# echo "DST_CHKSUM_FILE=${DST_CHKSUM_FILE}"
# exit 0

#计算较验码.
if [ -L "${SRC_FILE}" ]; then
    SRC_LINK_TARGET=$(readlink "${SRC_FILE}")
    CHKSUM_DATA_NEW=$(echo -n "${SRC_LINK_TARGET}" | sha256sum | awk "{print \$1}")
elif [ -f "${SRC_FILE}" ]; then
    CHKSUM_DATA_NEW=$(sha256sum "${SRC_FILE}" | awk "{print \$1}")
else
    exit 0
fi

#读取历史较验码.
CHKSUM_DATA_OLD=$(cat "${DST_CHKSUM_FILE}" 2>/dev/null)

#比较较验码, 判定是否需要重新备份.
if [ "${CHKSUM_DATA_NEW}" == "${CHKSUM_DATA_OLD}" ];then
{
    echo "跳过(文件无变化): '${SRC_FILE}'"
    exit 0
}
else
{
    #创建可能不存的路径.
    mkdir -p "${DST_PERV_PATH}"

    #符号链接与普通文件分开处理.
    if [ -L "${SRC_FILE}" ];then
    {
        #仅复制链接目标与源名字. 强制覆盖现存的.
        cp -f -d "${SRC_FILE}" "${DST_FILE}"
    }
    else 
    {
        #如果目录存在则删除所有旧的备份, 否则创建源名字同名目录.
        if [ -d "${DST_FILE}" ];then
            rm -f "${DST_FILE}/*"
        else
            mkdir -p "${DST_FILE}"
        fi

        #分卷备份, 每卷10MB.
        7z a -mx=0 -v10m -y "${DST_FILE}/${SRC_NAME}-shellkits" "${SRC_FILE}" > /dev/null
    }
    fi

    #保存校验码.
    echo "${CHKSUM_DATA_NEW}" > "${DST_CHKSUM_FILE}"
    echo "备份完成: ${SRC_FILE}"
}
fi
