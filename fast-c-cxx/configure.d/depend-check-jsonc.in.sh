#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

CHK=$(CheckKeyword ${WITH_PACKAGE} "jsonc")
if [ ${CHK} -gt 0 ];then
#
C_FLAGS=$(FindPKG_CFLAGS json-c ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MULTIARCH})
exit_if_error $? "'json-c' not found." $?
#
LD_FLAGS=$(FindPKG_LDFLAGS json-c ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MULTIARCH})
exit_if_error $? "'json-c' not found." $?
#
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_JSONC ${C_FLAGS}"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} ${LD_FLAGS}"
THIRDPARTY_ENABLE+=("HAVE_JSONC")
fi