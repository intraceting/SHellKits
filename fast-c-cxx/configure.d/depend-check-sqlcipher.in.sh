#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##


CHK=$(CheckKeyword ${WITH_PACKAGE} "sqlcipher")
if [ ${CHK} -gt 0 ];then
#
C_FLAGS=$(FindPKG_CFLAGS sqlite3 ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'sqlcipher' not found." $?
#
LD_FLAGS=$(FindPKG_LDFLAGS sqlite3 ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'sqlcipher' not found." $?
#
$(Check_SQLCipher ${SHELLKITS_TARGET_COMPILER_C} c99 has-codec ${THIRDPARTY_PREFIX})
HAC_CODEC=$?

#
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_SQLCIPHER ${C_FLAGS}"
if [ ${HAC_CODEC} -eq 0 ];then
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DSQLITE_HAS_CODEC"
fi 
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} ${LD_FLAGS}"
THIRDPARTY_ENABLE+=("HAVE_SQLCIPHER")
fi

