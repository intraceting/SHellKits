#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

CHK=$(CheckKeyword ${WITH_PACKAGE} "libmagic")
if [ ${CHK} -gt 0 ];then
#
C_FLAGS=$(FindPKG_CFLAGS libmagic ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MACHINE})
exit_if_error $? "'libmagic|FILE' not found." $?
#
LD_FLAGS=$(FindPKG_LDFLAGS libmagic ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MACHINE})
exit_if_error $? "'libmagic|FILE' not found." $?
#
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_LIBMAGIC ${C_FLAGS}"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} ${LD_FLAGS}"
THIRDPARTY_ENABLE+=("HAVE_LIBMAGIC")
fi