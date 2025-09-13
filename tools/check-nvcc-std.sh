#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# Copyright (c) 2021 The ABCDK project authors. All Rights Reserved.
# 
##
#
SHELLDIR=$(cd `dirname $0`; pwd)


#
if [ $# -ne 3 ];then
{
    exit 22
}
fi

#
COMPILER=$1
STD=$2
CCBIN=$3

#
${COMPILER} -std=${STD} -ccbin=${CCBIN} -Xcompiler -std=${STD} -c ${SHELLDIR}/test-nvcc-std/sample.cu >>/dev/null 2>&1
exit $?
