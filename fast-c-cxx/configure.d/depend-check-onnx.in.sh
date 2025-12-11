#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

CHK=$(CheckKeyword ${WITH_PACKAGE} "onnx")
if [ ${CHK} -gt 0 ];then
#
INC_PATH=$(FindINC_PATH "onnx/onnx_pb.h"  ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MACHINE})
exit_if_error $? "'onnx' not found." $?
#
LIB_PATH=$(FindLIB_PATH onnx ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MACHINE})
exit_if_error $? "'onnx' not found." $?
#
EXTRA_CXX_FLAGS="${EXTRA_CXX_FLAGS} -DHAVE_ONNX -I${INC_PATH}"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} -lonnx -L${LIB_PATH}"
THIRDPARTY_ENABLE+=("HAVE_ONNX")
fi