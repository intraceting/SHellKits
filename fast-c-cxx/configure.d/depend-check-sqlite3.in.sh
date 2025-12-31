#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##


CHK=$(CheckKeyword ${WITH_PACKAGE} "sqlite3")
if [ ${CHK} -gt 0 ];then
#
C_FLAGS=$(FindPKG_CFLAGS sqlite3 ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MULTIARCH})
exit_if_error $? "'sqlite3' not found." $?
#
LD_FLAGS=$(FindPKG_LDFLAGS sqlite3 ${THIRDPARTY_PREFIX} ${FAST_C_CXX_TARGET_MULTIARCH})
exit_if_error $? "'sqlite3' not found." $?
#
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_SQLITE ${C_FLAGS}"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} ${LD_FLAGS}"
THIRDPARTY_ENABLE+=("HAVE_SQLITE")
fi

