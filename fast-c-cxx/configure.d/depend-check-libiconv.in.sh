#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

CHK=$(CheckKeyword ${WITH_PACKAGE} "libiconv")
if [ ${CHK} -gt 0 ];then
#
INC_PATH=$(FindINC_PATH "iconv.h"  ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'libiconv' not found." $?
#
LIB_PATH=$(FindLIB_PATH iconv ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'libiconv' not found." $?
#
EXTRA_CXX_FLAGS="${EXTRA_CXX_FLAGS} -DHAVE_LIBICONV -I${INC_PATH}"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} -liconv -L${LIB_PATH}"
THIRDPARTY_ENABLE+=("HAVE_LIBICONV")
fi