#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# 
##
SHELLDIR=$(cd `dirname "$0"`; pwd)

#
CONTAINER_ID=$1

#
if [ "${CONTAINER_ID}" == "" ];then
echo "zh_CN.UTF-8: 必须指定容器ID或名字."
echo "en_US.UTF-8: You must specify a container ID or name."
exit 22
fi

#
find /usr/lib/ -name libnvcuvid.so* -exec docker cp  {} ${CONTAINER_ID}:{} \;
find /usr/lib/ -name libnvidia-encode.so* -exec docker cp  {} ${CONTAINER_ID}:{} \;
