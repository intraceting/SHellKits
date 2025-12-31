#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

CHK=$(CheckKeyword ${WITH_PACKAGE} "opencv")
if [ ${CHK} -gt 0 ];then
#
C_FLAGS=$(FindPKG_CFLAGS opencv4 ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MULTIARCH})
exit_if_error $? "'opencv|opencv4' not found." $?
#
LD_FLAGS=$(FindPKG_LDFLAGS opencv4 ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MULTIARCH})
exit_if_error $? "'opencv|opencv4' not found." $?
#
EXTRA_CXX_FLAGS="${EXTRA_CXX_FLAGS} -DHAVE_OPENCV ${C_FLAGS}"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} ${LD_FLAGS}"
THIRDPARTY_ENABLE+=("HAVE_OPENCV")
fi