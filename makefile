#
# This file is part of SHELLKITS.
#
# Copyright (c) 2026 The SHELLKITS project authors. All Rights Reserved.
#
#
MAKEFILE_DIR := $(dir $(shell realpath "$(lastword $(MAKEFILE_LIST))"))

#
BUILD_PATH ?= ${MAKEFILE_DIR}/build

#
INSTALL_PREFIX ?= /usr/local/shellkits

#
VERSION_MAJOR = 1
VERSION_MINOR = 0
VERSION_PATCH = 1

#
VERSION_STR_MAIN = ${VERSION_MAJOR}.${VERSION_MINOR}
VERSION_STR_FULL = ${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}

#伪目标, 告诉make这些都是标志, 而不是实体目录.
#因为如果标签和目录同名, 而目录内的文件没有更新的情况下, 编译和链接会跳过.如："XXX is up to date".
.PHONY: install uninstall build help package

#
all: 


#加载子项目.
#顺序不能更换.
include $(MAKEFILE_DIR)/makefile.install.mk

#
install: install-handy-utils install-cross-toolchain install-fast-c-cxx install-no-trouble-lfs

#
uninstall: uninstall-handy-utils uninstall-cross-toolchain uninstall-fast-c-cxx uninstall-no-trouble-lfs


#加载子项目.
#顺序不能更换.
include $(MAKEFILE_DIR)/makefile.package.mk

#
package: package-bin

#
clean-package: clean-package-bin

#
help:
	@echo "make"
	@echo "make install"
	@echo "make uninstall"
	@echo "make package"
	@echo "make clean-package"


