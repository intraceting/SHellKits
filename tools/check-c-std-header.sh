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
HEADER=$3

#
echo "#include <${HEADER}>" | ${COMPILER} -std=${STD} -x c -E - >/dev/null 2>&1
exit $?
