#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

CHK=$(CheckKeyword ${WITH_PACKAGE} "libarchive")
if [ ${CHK} -gt 0 ];then
#
C_FLAGS=$(FindPKG_CFLAGS libarchive ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MACHINE})
exit_if_error $? "'libarchive' not found." $?
#
LD_FLAGS=$(FindPKG_LDFLAGS libarchive ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MACHINE})
exit_if_error $? "'libarchive' not found." $?
#
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_ARCHIVE ${C_FLAGS}"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} ${LD_FLAGS}"
THIRDPARTY_ENABLE+=("HAVE_ARCHIVE")
fi