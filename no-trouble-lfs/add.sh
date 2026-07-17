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

#
MANIFEST_NAME=".no-trouble-lfs.manifest"
REPOSITORY_NAME=".no-trouble-lfs.repository"

#定位最近的文件清单路径.
TOP_PATH=$(${SHELLDIR}/locate.sh "${MANIFEST_NAME}")

#
if [ "${TOP_PATH}" == "" ];then
    exit_if_error 1 "The no-trouble-lfs environment is not initialized." 1
fi

#
MANIFEST_FILE="${TOP_PATH}/${MANIFEST_NAME}"
REPOSITORY_FILE="${TOP_PATH}/${REPOSITORY_NAME}"

#
while IFS= read -r ONE_FILE; do
{
    # '#'开头是注释.
    if [[ "${ONE_FILE}" =~ ^[[:space:][:cntrl:]]*# ]]; then
        continue
    fi

    # 去除控制字符.
    ONE_FILE="${ONE_FILE//[[:cntrl:]]/}"
    
    # 去除两端的空白字符.
    ONE_FILE="${ONE_FILE#"${ONE_FILE%%[![:space:]]*}"}"
    ONE_FILE="${ONE_FILE%"${ONE_FILE##*[![:space:]]}"}"

    # 过滤清洗后可能产生的空行.
    if [ "${ONE_FILE}" == "" ];then
        continue
    fi

    #
    if [ -f "${TOP_PATH}/${ONE_FILE}" ];then
    {
        ${SHELLDIR}/backup.sh "${REPOSITORY_FILE}" "${TOP_PATH}" "${ONE_FILE}"
        exit_if_error $? "" $?
    }
    else 
    {
        echo "忽略(文件不存在或非普通文件): '${ONE_FILE}'"
    }
    fi
}
done < "${MANIFEST_FILE}"
