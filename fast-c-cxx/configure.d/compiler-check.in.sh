#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##

#
(CheckSTD_C "${SHELLKITS_TARGET_COMPILER_C}" "${C_STD}")
if [ $? -ne 0 ];then
{
    echo "The compiler(C) supports at least the c99 standard."
    exit 22
}
fi

#
(CheckSTD_CXX "${SHELLKITS_TARGET_COMPILER_CXX}" "${CXX_STD}")
if [ $? -ne 0 ];then
{
    echo "The compiler(C++) supports at least the ${CXX_STD} standard."
    exit 22
}
fi

#
if [ "${COMPILER_CUDA_BIN}" != "" ];then
{
    #
    CheckSTD_NVCC ${COMPILER_CUDA_BIN} ${CXX_STD} "${SHELLKITS_TARGET_COMPILER_CXX}"
    if [ $? -ne 0 ];then
    {
        echo "The compiler(CU) supports at least the ${CXX_STD} standard."
        exit 22
    }
    fi
}
fi