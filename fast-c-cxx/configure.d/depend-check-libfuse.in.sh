#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

CHK=$(CheckKeyword ${WITH_PACKAGE} "libfuse3")
if [ ${CHK} -gt 0 ];then
#
C_FLAGS=$(FindPKG_CFLAGS fuse3 ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'fuse3|libfuse3' not found." $?
#
LD_FLAGS=$(FindPKG_LDFLAGS fuse3 ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'fuse3|libfuse3' not found." $?
#
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_LIBFUSE ${C_FLAGS}"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} ${LD_FLAGS}"
THIRDPARTY_ENABLE+=("HAVE_LIBFUSE")
fi