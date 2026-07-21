#
# This file is part of SHELLKITS.
#
# Copyright (c) 2026 The SHELLKITS project authors. All Rights Reserved.
#
#
#MAKEFILE_DIR := $(dir $(shell realpath "$(lastword $(MAKEFILE_LIST))"))

#生成KIT安装后执行脚本文件内容.
define KIT_POST_SHELL_CONTEXT
#
endef
export KIT_POST_SHELL_CONTEXT

#生成KIT卸载后执行脚本文件内容.
define KIT_POSTUN_SHELL_CONTEXT
#
endef
export KIT_POSTUN_SHELL_CONTEXT


#
SYSROOT_TMP = ${BUILD_PATH}/shellkits.sysroot.tmp/
#
KIT_FILE_LIST = ${SYSROOT_TMP}/kit.file.list
#
KIT_SYSROOT_TMP = ${SYSROOT_TMP}/kit.sysroot.tmp/

#
KIT_POST_SHELL_FILE = ${SYSROOT_TMP}/kit.post.sh
KIT_POSTUN_SHELL_FILE = ${SYSROOT_TMP}/kit.postun.sh

#
KIT_RPM_SPEC = ${SYSROOT_TMP}/kit.rpm.spec
KIT_DEB_SPEC = ${SYSROOT_TMP}/kit.deb.spec

#
KIT_DEB_REQUIRE_LIST = "libc-bin"
KIT_RPM_REQUIRE_LIST = "glibc"

#
ifeq (${PACKAGE_RELEASE_NAME},)
PACKAGE_RELEASE_NAME := $(shell date +%s)
endif

#
KIT_DEB_FILENAME = shellkits-${VERSION_STR_FULL}-${PACKAGE_RELEASE_NAME}-all.deb
KIT_RPM_FILENAME = shellkits-${VERSION_STR_FULL}-${PACKAGE_RELEASE_NAME}-noarch.rpm

#
prepare-kit:
	rm -rf ${KIT_SYSROOT_TMP}
	$(MAKE) -s -C ${MAKEFILE_DIR} INSTALL_PREFIX=${KIT_SYSROOT_TMP}/${INSTALL_PREFIX} install-handy-utils
	$(MAKE) -s -C ${MAKEFILE_DIR} INSTALL_PREFIX=${KIT_SYSROOT_TMP}/${INSTALL_PREFIX} install-cross-toolchain
	$(MAKE) -s -C ${MAKEFILE_DIR} INSTALL_PREFIX=${KIT_SYSROOT_TMP}/${INSTALL_PREFIX} install-fast-c-cxx
	$(MAKE) -s -C ${MAKEFILE_DIR} INSTALL_PREFIX=${KIT_SYSROOT_TMP}/${INSTALL_PREFIX} install-no-trouble-lfs
#
	find ${KIT_SYSROOT_TMP}/${INSTALL_PREFIX} -type f -printf "${INSTALL_PREFIX}/%P\n" > ${KIT_FILE_LIST}
	find ${KIT_SYSROOT_TMP}/${INSTALL_PREFIX} -type l -printf "${INSTALL_PREFIX}/%P\n" >> ${KIT_FILE_LIST}
#
	printf "%s" "$${KIT_POST_SHELL_CONTEXT}" > ${KIT_POST_SHELL_FILE}
	printf "%s" "$${KIT_POSTUN_SHELL_CONTEXT}" > ${KIT_POSTUN_SHELL_FILE}

#
package-deb-kit: prepare-kit
#生成SPEC文件.
	${MAKEFILE_DIR}/handy-utils/make.deb.rt.ctl.sh  \
	-d PACK_NAME=shellkits \
	-d VENDOR_NAME=INTRACETING\(traceting@gmail.com\) \
	-d OUTPUT=${KIT_DEB_SPEC} \
	-d VERSION_MAJOR=${VERSION_MAJOR} \
	-d VERSION_MINOR=${VERSION_MINOR} \
	-d VERSION_RELEASE=${VERSION_PATCH} \
	-d TARGET_PLATFORM="all" \
	-d FILES_NAME=${KIT_FILE_LIST} \
	-d POST_NAME=${KIT_POST_SHELL_FILE} \
	-d POSTUN_NAME=${KIT_POSTUN_SHELL_FILE} \
	-d REQUIRE_LIST=${KIT_DEB_REQUIRE_LIST}
#移动SPEC文件.
	mv ${KIT_DEB_SPEC} ${KIT_SYSROOT_TMP}/DEBIAN
#生成DEB文件.
	dpkg-deb --build ${KIT_SYSROOT_TMP} ${BUILD_PATH}/${KIT_DEB_FILENAME}
#移动SPEC文件.
	mv ${KIT_SYSROOT_TMP}/DEBIAN ${KIT_DEB_SPEC}

#
package-rpm-kit: prepare-kit
#生成SPEC文件.
	${MAKEFILE_DIR}/handy-utils/make.rpm.rt.spec.sh \
	-d PACK_NAME=shellkits \
	-d VENDOR_NAME=INTRACETING\(traceting@gmail.com\) \
	-d OUTPUT=${KIT_RPM_SPEC} \
	-d VERSION_MAJOR=${VERSION_MAJOR} \
	-d VERSION_MINOR=${VERSION_MINOR} \
	-d VERSION_RELEASE=${VERSION_PATCH} \
	-d TARGET_PLATFORM="noarch" \
	-d FILES_NAME=${KIT_FILE_LIST} \
	-d POST_NAME=${KIT_POST_SHELL_FILE} \
	-d POSTUN_NAME=${KIT_POSTUN_SHELL_FILE} \
	-d REQUIRE_LIST=${KIT_RPM_REQUIRE_LIST}
#生成RPM文件.
	rpmbuild --noclean \
	--target "noarch" \
	--buildroot ${KIT_SYSROOT_TMP} \
	-bb ${KIT_RPM_SPEC} \
	--define="_rpmdir ${BUILD_PATH}" \
	--define="_rpmfilename ${KIT_RPM_FILENAME}" \
	--define="%source_date_epoch_from_changelog 0"

#
package-kit: package-deb-kit package-rpm-kit

#
clean-package-kit:
	rm -rf ${KIT_SYSROOT_TMP}
	rm -rf ${KIT_FILE_LIST}
	rm -rf ${KIT_POST_SHELL_FILE}
	rm -rf ${KIT_POSTUN_SHELL_FILE}
	rm -rf ${KIT_RPM_SPEC}
	rm -rf ${KIT_DEB_SPEC}
