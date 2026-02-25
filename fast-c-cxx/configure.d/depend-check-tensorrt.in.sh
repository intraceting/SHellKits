#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

#
CHK=$(CheckKeyword ${WITH_PACKAGE} "tensorrt")
if [ ${CHK} -gt 0 ];then
#
INC_PATH=$(FindINC_PATH "NvInfer.h"  ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'tensorrt' not found." $?
#
LIB_PATH=$(FindLIB_PATH nvinfer ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'tensorrt' not found." $?
#
EXTRA_CXX_FLAGS="${EXTRA_CXX_FLAGS} -DHAVE_TENSORRT -I${INC_PATH}"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} -lnvinfer -lnvinfer_plugin -L${LIB_PATH}"
THIRDPARTY_ENABLE+=("HAVE_TENSORRT")
fi
