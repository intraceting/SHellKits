#!/bin/bash
#
# This file is part of TOOLCHAIN.
#  
# Copyright (c) 2026 The TOOLCHAIN project authors. All Rights Reserved.
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
CROSSTOOL_BIN=$(which ct-ng)
#
CROSSTOOL_HOME=${PWD}


#
if [ ! -f "${CROSSTOOL_BIN}" ] && [ ! -L "${CROSSTOOL_BIN}" ];then
exit_if_error 1 "'crosstool-ng' is not installed or not in the default location." 1
fi

#打印样本列表.
${CROSSTOOL_BIN} list-samples
exit_if_error $? "Failed to list samples or an error occurred." $?