#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

CHK=$(CheckKeyword ${WITH_PACKAGE} "qt6")
if [ ${CHK} -gt 0 ];then
#
if [ "${COMPILER_QMAKE_QT6}" == "" ];then
{
    BIN_PATH=$(FindBIN_PATH qmake-qt6 ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
    if [ $? -eq 0 ];then
        COMPILER_QMAKE_QT6=$(realpath -s "${BIN_PATH}/qmake-qt6")
    else 
    {
        BIN_PATH=$(FindBIN_PATH qmake ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
        exit_if_error $? "'qmake(Qt6)' not found." $?
        COMPILER_QMAKE_QT6=$(realpath -s "${BIN_PATH}/qmake")
    }
    fi
}
fi
#
QT6_MAJOR_VER=$(${COMPILER_QMAKE_QT6} -query QT_VERSION 2>>/dev/null | tr -cd '0-9.' | cut -d . -f 1)
if [ "${QT6_MAJOR_VER}" == "" ] || [ ${QT6_MAJOR_VER} -ne 6 ];then
exit_if_error 1 "'qmake(Qt6)' not found." 1
fi

#
EXTRA_CXX_FLAGS="${EXTRA_CXX_FLAGS} -DHAVE_QT6"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} "
THIRDPARTY_ENABLE+=("HAVE_QT6")
fi