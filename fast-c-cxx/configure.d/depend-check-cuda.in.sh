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
exit_if_error $? "'nvcc' not found." $?
COMPILER_NVCC=$(realpath -s "${BIN_PATH}/nvcc")
fi
#
CheckSTD_NVCC ${COMPILER_NVCC} ${CXX_STD} "${SHELLKITS_TARGET_COMPILER_CXX}"
exit_if_error $? "The compiler(${COMPILER_NVCC}) supports at least the ${CXX_STD} standard." $?

#
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_CUDA -I${INC_PATH}"
if [ "${SHELLKITS_TARGET_PLATFORM}" == "x86_64" ];then
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} -lcublasLt -lcublas -lcudart -lnppig -lnppc -lnppial -lnppicc -lnppidei -lnppif -lnppim -lnppisu -lnpps -lcuda -lnvjpeg -L${LIB_PATH} -L${LIB_PATH}/stubs"
else 
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} -lcublasLt -lcublas -lcudart -lnppig -lnppc -lnppial -lnppicc -lnppidei -lnppif -lnppim -lnppisu -lnpps -lcuda -L${LIB_PATH} -L${LIB_PATH}/stubs"
fi 
THIRDPARTY_ENABLE+=("HAVE_CUDA")
fi