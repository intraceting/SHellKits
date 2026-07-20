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
MANIFEST_NAME=".gitignore"
REPOSITORY_NAME=".ntlfs"

#定位最近的文件清单路径.
TOP_PATH=$(${SHELLDIR}/locate.sh "${MANIFEST_NAME}")

#
if [ "${TOP_PATH}" == "" ];then
    exit_if_error 1 "The ntlfs environment is not initialized." 1
fi

#
MANIFEST_FILE="${TOP_PATH}/${MANIFEST_NAME}"
REPOSITORY_FILE="${TOP_PATH}/${REPOSITORY_NAME}"

#
MANIFEST_BEGIN_KEY="# ntlfs-manifest-begin"
MANIFEST_END_KEY="# ntlfs-manifest-end"
MANIFEST_IS_VALID="no"

#
while IFS= read -r ONE_FILE; do
{
    # 先去尾部的空白或控制字符.
    ONE_FILE="${ONE_FILE%"${ONE_FILE##*[![:space:][:cntrl:]]}"}"

    # 再去首部的空白或控制字符.
    ONE_FILE="${ONE_FILE#"${ONE_FILE%%[![:space:][:cntrl:]]*}"}"

    # 过滤清洗后可能产生的空行.
    if [ "${ONE_FILE}" == "" ];then
        continue
    fi

    # '#'开头是注释. (正则表达式需要双层括号)
    if [[ "${ONE_FILE}" =~ ^# ]]; then
    {
        if [ "${MANIFEST_BEGIN_KEY}" == "${ONE_FILE}" ];then
            MANIFEST_IS_VALID="yes"
        elif [ "${MANIFEST_END_KEY}" == "${ONE_FILE}" ];then
            MANIFEST_IS_VALID="no"
        fi

        # 下一行.
        continue
    }
    fi

    # 未进入清单区间时跳过.
    if [ "${MANIFEST_IS_VALID}" != "yes" ];then
        continue
    fi

    #
    ${SHELLDIR}/restore.sh "${REPOSITORY_FILE}" "${TOP_PATH}" "${ONE_FILE}"
    exit_if_error $? "" $?

}
done < "${MANIFEST_FILE}"
