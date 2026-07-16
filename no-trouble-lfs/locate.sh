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
TARGET_NAME="$1"
#
CURRENT_DIR="$(pwd)"

#    
while true; do
{    
    #判断是否存在.
    if [ -e "${CURRENT_DIR}/${TARGET_NAME}" ]; then
        echo "${CURRENT_DIR}"
        exit 0
    fi

    #已是根目录时终止.
    if [ "${CURRENT_DIR}" = "/" ]; then
        exit 1
    fi

    #上一层.
    CURRENT_DIR="$(dirname "$CURRENT_DIR")"
}
done