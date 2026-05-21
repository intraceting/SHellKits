#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2026 The SHELLKITS project authors. All Rights Reserved.
# 
##
#
SHELLDIR=$(cd `dirname $0`; pwd)

#
if [ $# -ne 4 ];then
{
    exit 22
}
fi

#
COMPILER=$1
STD=$2
CASE=$3
PREFIX="$4"

#
MULTIARCH=$(${SHELLDIR}/get-compiler-multiarch.sh "${COMPILER}")
BITWIDE=$(${SHELLDIR}/get-compiler-bitwide.sh "${COMPILER}")

#拆分路径到数组.
IFS=':' read -r -a CHK_LIST <<< "${PREFIX}"

#
for ONE_PATH in "${CHK_LIST[@]}"; do
{
    #
    if [ "${ONE_PATH}" == "" ];then
        continue;
    fi

    #
    if [ -d "${ONE_PATH}/include" ];then
        OPT="${OPT} -I${ONE_PATH}/include"
    fi

    #
    if [ -d "${ONE_PATH}/inc" ];then
        OPT="${OPT} -I${ONE_PATH}/inc"
    fi

    #
    if [ -d "${ONE_PATH}/lib${BITWIDE}" ];then
        OPT="${OPT} -L${ONE_PATH}/lib${BITWIDE} -Wl,-rpath-link=${ONE_PATH}/lib${BITWIDE}"
    fi
    
    #
    if [ -d "${ONE_PATH}/lib" ];then
        OPT="${OPT} -L${ONE_PATH}/lib -Wl,-rpath-link=${ONE_PATH}/lib"
    fi

    #
    if [ -d "${ONE_PATH}/lib/${MULTIARCH}" ];then
        OPT="${OPT} -L${ONE_PATH}/lib/${MULTIARCH} -Wl,-rpath-link=${ONE_PATH}/lib/${MULTIARCH}"
    fi

    #
    if [ -d "${ONE_PATH}/${MULTIARCH}/lib" ];then
        OPT="${OPT} -L${ONE_PATH}/${MULTIARCH}/lib -Wl,-rpath-link=${ONE_PATH}/${MULTIARCH}/lib"
    fi
}
done

#
OPT="${OPT} -lsqlite3"

#
${COMPILER} ${SHELLDIR}/test-sqlcipher/${CASE}.c -x c -o /dev/null -std=${STD} ${OPT} 2>>/dev/null
exit $?
