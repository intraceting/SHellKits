#
# This file is part of SHELLKITS.
#
# Copyright (c) 2026 The SHELLKITS project authors. All Rights Reserved.
#
#
#MAKEFILE_DIR := $(dir $(shell realpath "$(lastword $(MAKEFILE_LIST))"))

#
install-handy-utils:
#
	mkdir -p -m 0755 ${INSTALL_PREFIX}/shellkits/handy-utils
	cp -rfP $(MAKEFILE_DIR)/handy-utils/. ${INSTALL_PREFIX}/shellkits/handy-utils/
	find ${INSTALL_PREFIX}/shellkits/handy-utils -type d -exec chmod 0755 {} \;
	find ${INSTALL_PREFIX}/shellkits/handy-utils -type f -exec chmod 0644 {} \;
#双引号很重要, 下同. 如果未加双引号, '*.sh' 会被makefile解析并匹配成 '.sh' .
	find ${INSTALL_PREFIX}/shellkits/handy-utils -type f -name "*.sh" -exec chmod 0555 {} \;

#
uninstall-handy-utils:
#
	rm -rf ${INSTALL_PREFIX}/shellkits/handy-utils
	rmdir --ignore-fail-on-non-empty ${INSTALL_PREFIX}/shellkits

#
install-cross-toolchain:
#
	mkdir -p -m 0755 ${INSTALL_PREFIX}/shellkits/cross-toolchain
	cp -rfP $(MAKEFILE_DIR)/cross-toolchain/. ${INSTALL_PREFIX}/shellkits/cross-toolchain/
	find ${INSTALL_PREFIX}/shellkits/cross-toolchain -type d -exec chmod 0755 {} \;
	find ${INSTALL_PREFIX}/shellkits/cross-toolchain -type f -exec chmod 0644 {} \;
	find ${INSTALL_PREFIX}/shellkits/cross-toolchain -type f -name "*.sh" -exec chmod 0555 {} \;

#
uninstall-cross-toolchain:
#
	rm -rf ${INSTALL_PREFIX}/shellkits/cross-toolchain
	rmdir --ignore-fail-on-non-empty ${INSTALL_PREFIX}/shellkits

#
install-fast-c-cxx:
#
	mkdir -p -m 0755 ${INSTALL_PREFIX}/shellkits/fast-c-cxx
	cp -rfP $(MAKEFILE_DIR)/fast-c-cxx/. ${INSTALL_PREFIX}/shellkits/fast-c-cxx/
	find ${INSTALL_PREFIX}/shellkits/fast-c-cxx -type d -exec chmod 0755 {} \;
	find ${INSTALL_PREFIX}/shellkits/fast-c-cxx -type f -exec chmod 0644 {} \;
	find ${INSTALL_PREFIX}/shellkits/fast-c-cxx -type f -name "*.sh" -exec chmod 0555 {} \;

#
uninstall-fast-c-cxx:
#
	rm -rf ${INSTALL_PREFIX}/shellkits/fast-c-cxx
	rmdir --ignore-fail-on-non-empty ${INSTALL_PREFIX}/shellkits


#
install-no-trouble-lfs:
#
	mkdir -p -m 0755 ${INSTALL_PREFIX}/shellkits/no-trouble-lfs
	cp -rfP $(MAKEFILE_DIR)/no-trouble-lfs/. ${INSTALL_PREFIX}/shellkits/no-trouble-lfs/
	find ${INSTALL_PREFIX}/shellkits/no-trouble-lfs -type d -exec chmod 0755 {} \;
	find ${INSTALL_PREFIX}/shellkits/no-trouble-lfs -type f -exec chmod 0644 {} \;
	find ${INSTALL_PREFIX}/shellkits/no-trouble-lfs -type f -name "*.sh" -exec chmod 0555 {} \;

#
uninstall-no-trouble-lfs:
#
	rm -rf ${INSTALL_PREFIX}/shellkits/no-trouble-lfs
	rmdir --ignore-fail-on-non-empty ${INSTALL_PREFIX}/shellkits

