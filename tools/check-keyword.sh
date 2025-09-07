#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# Copyright (c) 2025 The ABCDK project authors. All Rights Reserved.
##

#
SHELLDIR=$(cd `dirname $0`; pwd)

#
if [ $# -ne 2 ];then
    echo "0"
    exit 22
fi

#
NUM=$(echo "$1" |grep -wi "$2" | wc -l)
echo ${NUM}

#
exit 0