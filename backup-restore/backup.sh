#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2026 The SHELLKITS project authors. All Rights Reserved.
##
#
#
SHELLDIR=$(cd `dirname "$0"`; pwd)

# 
if [ "${#}" -ne 2 ]; then
    echo "使用方法: ${0} <源目录> <备份目录>"
    exit 1
fi

# 获取源目录和目标目录的绝对路径
SRC_DIR=$(realpath -m "${1}")
DST_DIR=$(realpath -m "${2}")

#仅备份符号链接或普通文件.
find "${SRC_DIR}/" \( -type l -o -type f \) -exec "${SHELLDIR}/backup-single.sh" "${DST_DIR}" {} "${SRC_DIR}/" \;