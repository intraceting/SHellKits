#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##


CHK=$(CheckKeyword ${WITH_PACKAGE} "icu")
if [ ${CHK} -gt 0 ];then
#
C_FLAGS=$(FindPKG_CFLAGS "icu-io icu-uc icu-i18n" ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'icu' not found." $?
#
LD_FLAGS=$(FindPKG_LDFLAGS "icu-io icu-uc icu-i18n" ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'icu' not found." $?
#
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_ICU ${C_FLAGS}"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} ${LD_FLAGS}"
THIRDPARTY_ENABLE+=("HAVE_ICU")
fi

