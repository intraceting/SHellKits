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

#检查参数.
if [ "${#}" -ne 3 ]; then
    echo "使用方法: ${0} <备份目录>  <源文件> <源前缀>"
    exit 1
fi

#
DST_PATH=$(realpath -s -m "${1}")
SRC_FILE=$(realpath -s -m "${2}")
SRC_PERFIX=$(realpath -s -m "${3}")

#提取源文件名.
SRC_NAME="${SRC_FILE##*/}"

#提取源文件相对路径,并接到备份目录后面.
DST_FILE="${DST_PATH}/${SRC_FILE#${SRC_PERFIX}}"

#提取备份文件上级路径.
DST_PERV_PATH="${DST_FILE%/*}"

#备份文件较验码文件.
DST_CHKSUM_FILE="${DST_FILE}-shellkits.checksum.sha256"

#备份文件分卷前缀.
DST_VOLUME_PERFIX="${DST_FILE}/${SRC_NAME}-shellkits.rawdata"

#备份文件的属性文件.
DST_ATTR_FILE="${DST_FILE}-shellkits.attribute.txt"

#
# echo "DST_PATH=${DST_PATH}"
# echo "SRC_FILE=${SRC_FILE}"
# echo "SRC_PERFIX=${SRC_PERFIX}"
# echo "SRC_NAME=${SRC_NAME}"
# echo "DST_FILE=${DST_FILE}"
# echo "DST_PERV_PATH=${DST_PERV_PATH}"
# echo "DST_CHKSUM_FILE=${DST_CHKSUM_FILE}"
# echo "DST_VOLUME_PERFIX=${DST_VOLUME_PERFIX}"
# echo "DST_ATTR_FILE=${DST_ATTR_FILE}"
# exit 0

#获取新的权限.
PERM_DATA_NEW=$(stat -c "%a" "${SRC_FILE}" 2>/dev/null)

#读取旧的权限.
PERM_DATA_OLD=$(cat "${DST_ATTR_FILE}" 2>/dev/null)

#计算新的较验码.
if [ -L "${SRC_FILE}" ]; then
    SRC_LINK_TARGET=$(readlink "${SRC_FILE}")
    CHKSUM_DATA_NEW=$(echo -n "${SRC_LINK_TARGET}" | sha256sum | awk "{print \$1}")
elif [ -f "${SRC_FILE}" ]; then
    CHKSUM_DATA_NEW=$(sha256sum "${SRC_FILE}" | awk "{print \$1}")
else
    exit 0
fi

#读取旧的较验码.
CHKSUM_DATA_OLD=$(cat "${DST_CHKSUM_FILE}" 2>/dev/null)

#比较较验码, 判定是否需要重新备份.
if [ "${CHKSUM_DATA_NEW}" == "${CHKSUM_DATA_OLD}" ];then
{
    echo "跳过(文件无变化): '${SRC_FILE}'"

    if [ -L "${SRC_FILE}" ];then
    {
        echo -n ""
    }
    elif [ "${PERM_DATA_NEW}" != "${PERM_DATA_OLD}" ];then
    {
        #同步属性.
        echo "${PERM_DATA_NEW}" > "${DST_ATTR_FILE}"
        echo "原文件的属性发生变更, 备份文件的属性同步完成."
    }
    fi
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
        7z a -mx=0 -v10m -y "${DST_VOLUME_PERFIX}" "${SRC_FILE}" > /dev/null
    }
    fi

    #保存属性.
    echo "${PERM_DATA_NEW}" > "${DST_ATTR_FILE}"
    #保存校验码.
    echo "${CHKSUM_DATA_NEW}" > "${DST_CHKSUM_FILE}"

    echo "备份完成: ${SRC_FILE}"
}
fi
