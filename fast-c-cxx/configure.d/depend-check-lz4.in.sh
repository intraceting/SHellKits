#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

#
CHK=$(CheckKeyword ${WITH_PACKAGE} "lz4")
if [ ${CHK} -gt 0 ];then
#
C_FLAGS=$(FindPKG_CFLAGS liblz4 ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MULTIARCH})
exit_if_error $? "'liblz4' not found." $?
#
LD_FLAGS=$(FindPKG_LDFLAGS liblz4 ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MULTIARCH})
exit_if_error $? "'liblz4' not found." $?
#
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_LZ4 ${C_FLAGS}"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} ${LD_FLAGS}"
THIRDPARTY_ENABLE+=("HAVE_LZ4")
fi