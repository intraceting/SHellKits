#
# This file is part of SHELLKITS.
#
# Copyright (c) 2026 The SHELLKITS project authors. All Rights Reserved.
#
#
#MAKEFILE_DIR := $(dir $(shell realpath "$(lastword $(MAKEFILE_LIST))"))

#生成BIN安装后执行脚本文件内容.
define BIN_POST_SHELL_CONTEXT
#
endef
export BIN_POST_SHELL_CONTEXT

#生成BIN卸载后执行脚本文件内容.
define BIN_POSTUN_SHELL_CONTEXT
#
endef
export BIN_POSTUN_SHELL_CONTEXT


#
SYSROOT_TMP = ${BUILD_PATH}/shellkits.sysroot.tmp/
#
BIN_FILE_LIST = ${SYSROOT_TMP}/bin.file.list
#
BIN_SYSROOT_TMP = ${SYSROOT_TMP}/bin.sysroot.tmp/

#
BIN_POST_SHELL_FILE = ${SYSROOT_TMP}/bin.post.sh
BIN_POSTUN_SHELL_FILE = ${SYSROOT_TMP}/bin.postun.sh

#
BIN_RPM_SPEC = ${SYSROOT_TMP}/bin.rpm.spec
BIN_DEB_SPEC = ${SYSROOT_TMP}/bin.deb.spec

#
BIN_DEB_REQUIRE_LIST = "libc-bin"
BIN_RPM_REQUIRE_LIST = "glibc"

#
ifeq (${PACKAGE_RELEASE_NAME},)
PACKAGE_RELEASE_NAME := $(shell date +%s)
endif

#
BIN_DEB_FILENAME = shellkits-bin-${VERSION_STR_FULL}-${PACKAGE_RELEASE_NAME}-all.deb
BIN_RPM_FILENAME = shellkits-bin-${VERSION_STR_FULL}-${PACKAGE_RELEASE_NAME}-all.rpm

#
prepare-bin:
	rm -rf ${BIN_SYSROOT_TMP}
	$(MAKE) -s -C ${MAKEFILE_DIR} INSTALL_PREFIX=${BIN_SYSROOT_TMP}/${INSTALL_PREFIX} install-handy-utils
	$(MAKE) -s -C ${MAKEFILE_DIR} INSTALL_PREFIX=${BIN_SYSROOT_TMP}/${INSTALL_PREFIX} install-cross-toolchain
	$(MAKE) -s -C ${MAKEFILE_DIR} INSTALL_PREFIX=${BIN_SYSROOT_TMP}/${INSTALL_PREFIX} install-fast-c-cxx
	$(MAKE) -s -C ${MAKEFILE_DIR} INSTALL_PREFIX=${BIN_SYSROOT_TMP}/${INSTALL_PREFIX} install-no-trouble-lfs
#
	find ${BIN_SYSROOT_TMP}/${INSTALL_PREFIX} -type f -printf "${INSTALL_PREFIX}/%P\n" > ${BIN_FILE_LIST}
	find ${BIN_SYSROOT_TMP}/${INSTALL_PREFIX} -type l -printf "${INSTALL_PREFIX}/%P\n" >> ${BIN_FILE_LIST}
#
	printf "%s" "$${BIN_POST_SHELL_CONTEXT}" > ${BIN_POST_SHELL_FILE}
	printf "%s" "$${BIN_POSTUN_SHELL_CONTEXT}" > ${BIN_POSTUN_SHELL_FILE}

#
package-deb-bin: prepare-bin
#生成SPEC文件.
	${MAKEFILE_DIR}/handy-utils/make.deb.rt.ctl.sh  \
	-d PACK_NAME=shellkits-bin \
	-d VENDOR_NAME=INTRACETING\(traceting@gmail.com\) \
	-d OUTPUT=${BIN_DEB_SPEC} \
	-d VERSION_MAJOR=${VERSION_MAJOR} \
	-d VERSION_MINOR=${VERSION_MINOR} \
	-d VERSION_RELEASE=${VERSION_PATCH} \
	-d TARGET_PLATFORM="all" \
	-d FILES_NAME=${BIN_FILE_LIST} \
	-d POST_NAME=${BIN_POST_SHELL_FILE} \
	-d POSTUN_NAME=${BIN_POSTUN_SHELL_FILE} \
	-d REQUIRE_LIST=${BIN_DEB_REQUIRE_LIST}
#移动SPEC文件.
	mv ${BIN_DEB_SPEC} ${BIN_SYSROOT_TMP}/DEBIAN
#生成DEB文件.
	dpkg-deb --build ${BIN_SYSROOT_TMP} ${BUILD_PATH}/${BIN_DEB_FILENAME}
#移动SPEC文件.
	mv ${BIN_SYSROOT_TMP}/DEBIAN ${BIN_DEB_SPEC}

#
package-rpm-bin: prepare-bin
#生成SPEC文件.
	${MAKEFILE_DIR}/handy-utils/make.rpm.rt.spec.sh \
	-d PACK_NAME=shellkits-bin \
	-d VENDOR_NAME=INTRACETING\(traceting@gmail.com\) \
	-d OUTPUT=${BIN_RPM_SPEC} \
	-d VERSION_MAJOR=${VERSION_MAJOR} \
	-d VERSION_MINOR=${VERSION_MINOR} \
	-d VERSION_RELEASE=${VERSION_PATCH} \
	-d TARGET_PLATFORM="all" \
	-d FILES_NAME=${BIN_FILE_LIST} \
	-d POST_NAME=${BIN_POST_SHELL_FILE} \
	-d POSTUN_NAME=${BIN_POSTUN_SHELL_FILE} \
	-d REQUIRE_LIST=${BIN_RPM_REQUIRE_LIST}
#生成RPM文件.
	rpmbuild --noclean \
	--target="all" \
	--buildroot ${BIN_SYSROOT_TMP} \
	-bb ${BIN_RPM_SPEC} \
	--define="_rpmdir ${BUILD_PATH}" \
	--define="_rpmfilename ${BIN_RPM_FILENAME}" \
	--define="%source_date_epoch_from_changelog 0"

#
package-bin: package-deb-bin package-rpm-bin

#
clean-package-bin:
	rm -rf ${BIN_SYSROOT_TMP}
	rm -rf ${BIN_FILE_LIST}
	rm -rf ${BIN_POST_SHELL_FILE}
	rm -rf ${BIN_POSTUN_SHELL_FILE}
	rm -rf ${BIN_RPM_SPEC}
	rm -rf ${BIN_DEB_SPEC}
