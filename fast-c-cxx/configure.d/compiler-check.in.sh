#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

#
(CheckSTD_C "${SHELLKITS_TARGET_COMPILER_C}" "${C_STD}")
exit_if_error $?  "The compiler(C) supports at least the ${C_STD} standard." $?

#
(CheckSTD_CXX "${SHELLKITS_TARGET_COMPILER_CXX}" "${CXX_STD}")
exit_if_error $?  "The compiler(C++) supports at least the ${CXX_STD} standard." $?

