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
ONE_NAME="${1}"
#
IFS=":" read -ra PATH_VECTOR <<< "${2}"

#
for ONE_PATH in "${PATH_VECTOR[@]}"; do
{
    ONE_PATH_FILE="${ONE_PATH}/${ONE_NAME}"
    
    if [ -e "${ONE_PATH_FILE}" ];then
    {
        echo "$(realpath -s ${ONE_PATH_FILE})"
        exit 0
    }
    fi
}
done

#
exit 2