#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

CHK=$(CheckKeyword ${WITH_PACKAGE} "faiss")
if [ ${CHK} -gt 0 ];then
#
INC_PATH=$(FindINC_PATH "faiss/Index.h"  ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MACHINE})
exit_if_error $? "'faiss' not found." $?
#
LIB_PATH=$(FindLIB_PATH faiss ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MACHINE})
exit_if_error $? "'faiss' not found." $?
#
EXTRA_CXX_FLAGS="${EXTRA_CXX_FLAGS} -DHAVE_FAISS -I${INC_PATH}"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} -lfaiss -L${LIB_PATH}"
THIRDPARTY_ENABLE+=("HAVE_FAISS")
fi