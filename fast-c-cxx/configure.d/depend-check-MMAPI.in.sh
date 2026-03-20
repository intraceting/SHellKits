#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2026 The SHELLKITS project authors. All Rights Reserved.
##

#
CHK=$(CheckKeyword ${WITH_PACKAGE} "MMAPI")
if [ ${CHK} -gt 0 ];then

#
ETC_PATH=$(FindETC_PATH nv_tegra_release ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'MMAPI' not found." $?

#提取版本号.
MMAPI_VERSION=$(cat ${ETC_PATH}/nv_tegra_release | grep -oP '(?<=# R)\d+|(?<=REVISION: )\d+\.\d+' | tr '\n' '.' | sed 's/\.$//')
if [ "${MMAPI_VERSION}" == "" ];then
exit_if_error 1 "'MMAPI' not found." 1
fi

#
LIB_PATH=$(FindLIB_PATH "nvidia/libnvbufsurface.so" ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'MMAPI' not found." $?

#
LIB_PATH=$(FindLIB_PATH "drm" ${THIRDPARTY_PREFIX} ${SHELLKITS_TARGET_MULTIARCH})
exit_if_error $? "'MMAPI' not found." $?

#
EXTRA_CXX_FLAGS="${EXTRA_CXX_FLAGS} -DHAVE_MMAPI"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} -lnvv4l2 -lnvbufsurface -lnvbufsurftransform -lnvjpeg -lnvosd -ldrm -L${LIB_PATH} -L${LIB_PATH}/nvidia"
THIRDPARTY_ENABLE+=("HAVE_MMAPI")
fi
