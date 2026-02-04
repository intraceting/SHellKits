#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

CHK=$(CheckKeyword ${WITH_PACKAGE} "qt5")
if [ ${CHK} -gt 0 ];then
#
INC_PATH=$(FindINC_PATH "QtCore/QObject"  ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'Qt5' not found." $?
#
LIB_PATH=$(FindLIB_PATH Qt5Core ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'Qt5' not found." $?
#
if [ "${COMPILER_QMAKE}" == "" ];then
BIN_PATH=$(FindBIN_PATH qmake ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
if [ $? -eq 0 ];then
COMPILER_QMAKE=$(realpath -s "${BIN_PATH}/qmake-qt5")
else 
BIN_PATH=$(FindBIN_PATH qmake ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'qmake(Qt5)' not found." $?
COMPILER_QMAKE=$(realpath -s "${BIN_PATH}/qmake")
fi
fi
#
#EXTRA_CXX_FLAGS="${EXTRA_CXX_FLAGS} -DHAVE_QT"
#EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} -L${LIB_PATH}"
EXTRA_CXX_FLAGS="${EXTRA_CXX_FLAGS} -DHAVE_QT"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} "
THIRDPARTY_ENABLE+=("HAVE_QT")
fi