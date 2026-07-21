#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# 
##
SHELLDIR=$(cd `dirname "$0"`; pwd)

#
function read_needed_list()
{
    readelf -d "${1}" 2>>/dev/null | grep "(NEEDED)" | grep -oP '\[\K[^\]]+(?=\])'
}

#
function which_one()
{
    ${SHELLDIR}/which-one.sh "$1" "$2"
}

#
if [ $# -ne 3 ];then
    exit 22
fi

#
TARGET_FILE=$(realpath -s ${1})
#
LIB_PATH="${2}"
#
LIST_FILE="${3}"

#Find direct dependency packages.　
NEEDED_LIST=($(read_needed_list ${TARGET_FILE}))

#
for (( i=0; i<${#NEEDED_LIST[@]}; i++ )); do
{
    #
    ONE_NAME="${NEEDED_LIST[$i]}"
    ONE_LIB_FILE=$(which_one "${ONE_NAME}" "${LIB_PATH}")

    #
    if [ "${ONE_LIB_FILE}" != "" ];then
    {
        echo "${ONE_LIB_FILE}" >> ${LIST_FILE}

        if [ -L "${ONE_LIB_FILE}" ];then
        {
            LINK_NAME=$(readlink "${ONE_LIB_FILE}")

            # /* 匹配以 / 开头的任意字符串.
            # [[ ... ]] 支持模式匹配.
            if [[ ${LINK_NAME} == /* ]];then
            {
                echo "${LINK_NAME}" >> ${LIST_FILE}

                $0 "$(basename ${LINK_NAME})" "$(dirname ${LINK_NAME})" "${LIST_FILE}" 
            }
            else
            {
                ONE_LIB_FILE=$(realpath -s "$(dirname "${ONE_LIB_FILE}")/${LINK_NAME}")

                echo "${ONE_LIB_FILE}" >> ${LIST_FILE}

                NEEDED_LIST+=($(read_needed_list ${ONE_LIB_FILE}))
            }
            fi
        }
        elif [ -f "${ONE_LIB_FILE}" ];then
        {
            NEEDED_LIST+=($(read_needed_list ${ONE_LIB_FILE}))
        }
        fi
    }
    else
    {
        echo "NoFound '${ONE_NAME}'. "
    }
    fi
}
done

#
exit 0