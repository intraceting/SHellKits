#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

CHK=$(CheckKeyword ${WITH_PACKAGE} "cudnn")
if [ ${CHK} -gt 0 ];then
#
INC_PATH=$(FindINC_PATH "cudnn.h"  ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'cudnn' not found." $?
#
LIB_PATH=$(FindLIB_PATH cudnn ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'cudnn' not found." $?
#
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_CUDNN -I${INC_PATH}"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} -lcudnn -L${LIB_PATH}"
THIRDPARTY_ENABLE+=("HAVE_CUDNN")
fi