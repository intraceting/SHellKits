#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

CHK=$(CheckKeyword ${WITH_PACKAGE} "live555")
if [ ${CHK} -gt 0 ];then
#
INC_PATH=$(FindINC_PATH "liveMedia/liveMedia.hh"  ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MULTIARCH})
exit_if_error $? "'live555|liveMedia' not found." $?
#
LIB_PATH=$(FindLIB_PATH liveMedia ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MULTIARCH})
exit_if_error $? "'live555|liveMedia' not found." $?
#
EXTRA_CXX_FLAGS="${EXTRA_CXX_FLAGS} -DHAVE_LIVE555 -DNO_STD_LIB -I${INC_PATH}/liveMedia -I${INC_PATH}/BasicUsageEnvironment -I${INC_PATH}/groupsock -I${INC_PATH}/UsageEnvironment"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} -lliveMedia -lUsageEnvironment -lgroupsock -lBasicUsageEnvironment -L${LIB_PATH}"
THIRDPARTY_ENABLE+=("HAVE_LIVE555")
fi