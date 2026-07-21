#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# 
##
SHELLDIR=$(cd `dirname "$0"`; pwd)

#
if [ $# -ne 2 ];then
    exit 22
fi

#
FILE_LIST=$1
TARGET_PATH=$2

#去掉重复的依赖组件.
NEEDED_LIST=($(awk '!seen[$0]++' ${FILE_LIST}))

#复制依赖组件到LIB目录.
for ONE_NEEDED in "${NEEDED_LIST[@]}"; do
{
    #
    ONE_NAME=$(basename ${ONE_NEEDED})

    #
    if [ ! -e "${TARGET_PATH}/${ONE_NAME}" ];then
    {
        mkdir -p ${TARGET_PATH}
        cp -fP ${ONE_NEEDED} ${TARGET_PATH}/
    }
    fi
}
done
