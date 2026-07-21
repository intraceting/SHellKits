#!/bin/bash
#
# This file is part of SHELLKITS.

# Copyright (c) 2026 The SHELLKITS project authors. All Rights Reserved.
##
#
SHELLDIR=$(cd `dirname "$0"`; pwd)
SHELLNAME=$(basename "$0")

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

#记录启动工作路径.
STARTUP_PATH=${PWD}

#
TMP_HOME_A=$(realpath -s "${SHELLDIR}")
TMP_HOME_B=$(realpath -s "${STARTUP_PATH}")

#不允许脚本所在目录运行.
if [ "${TMP_HOME_A}" == "${TMP_HOME_B}" ];then
    exit_if_error 1 "Scripts cannot be run from the directory where they are located." 1
fi


#
BUILD_LOG=dist.log
#
echo "" > ${BUILD_LOG}

#
make -C ${SHELLDIR} package >> ${BUILD_LOG} 2>&1
exit_if_error $? "打包过程发生错误. 见: '${BUILD_LOG}'" $?

#
make -C ${SHELLDIR} clean-package  >> ${BUILD_LOG} 2>&1
exit_if_error $? "清理过程发生错误. 见: '${BUILD_LOG}'" $?

#
mkdir -p dist-package/{deb,rpm}

#收集发行包.
mv -f *.deb dist-package/deb/
mv -f *.rpm dist-package/rpm/