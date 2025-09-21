#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# 
##
SHELLDIR=$(cd `dirname "$0"`; pwd)

# Functions
checkReturnCode()
{
    rc=$?
    if [ $rc != 0 ];then
        exit $rc
    fi
}

#
if [ $# -ne 5 ];then
    exit 22
fi

#
PKG_NAME=${1}
PKG_VER=${2}
KW_PREFIX=${3}
SRC_DIR=$(realpath -s ${4})
OUT_POT=$(realpath -s ${5})

#default.
if [ "${SRC_WILDCARDS}" == "" ];then
SRC_WILDCARDS="*.c:*.cc:*.cx:*.cpp:*.cxx:*.hxx:*.hpp:*.cu:*.gpu"
fi

#
IFS=":" read -ra WILDCARDS_VECTOR <<< "${SRC_WILDCARDS}"

#
SRC_FILELIST=${OUT_POT}.xgettext.filelist

#clear.
> ${SRC_FILELIST}
checkReturnCode

#
for ONE_KEY in "${WILDCARDS_VECTOR[@]}"; do
{
    find ${SRC_DIR} -name "${ONE_KEY}" >> ${SRC_FILELIST};
}
done

#
if [ ! -f "${SRC_FILELIST}" ];then
exit 2
fi

#
xgettext --force-po --no-wrap --no-location --join-existing --from-code=UTF-8 -L c++ \
    --package-name=${PKG_NAME} \
    --package-version=${PKG_VER} \
    --keyword=${KW_PREFIX} \
    -o ${OUT_POT} \
    -f ${SRC_FILELIST}
checkReturnCode

#
rm -f ${SRC_FILELIST}

