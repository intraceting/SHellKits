#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

CHK=$(CheckKeyword ${WITH_PACKAGE} "cuda")
if [ ${CHK} -gt 0 ];then
#
INC_PATH=$(FindINC_PATH "cuda.h"  ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'cuda' not found." $?
#
LIB_PATH=$(FindLIB_PATH cudart ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'cuda' not found." $?
#
if [ "${COMPILER_NVCC}" == "" ];then
BIN_PATH=$(FindBIN_PATH nvcc ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
COMPILER_NVCC=$(realpath -s "${BIN_PATH}/nvcc")
fi
#
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_CUDA -I${INC_PATH}"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} -lcublasLt -lcublas -lcudart -lnppig -lnppc -lnppial -lnppicc -lnppidei -lnppif -lnppim -lnppisu -lnpps -lnvjpeg -lcuda -L${LIB_PATH} -L${LIB_PATH}/stubs"
THIRDPARTY_ENABLE+=("HAVE_CUDA")
fi