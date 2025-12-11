#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
##


(CheckHeader_C "${FAST_C_CXX_TARGET_COMPILER_C}" ${C_STD} "libintl.h") 
if [ $? -eq 0 ];then
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_LIBINTL_H"
THIRDPARTY_ENABLE+=("HAVE_LIBINTL_H")
fi

(CheckHeader_C "${FAST_C_CXX_TARGET_COMPILER_C}" ${C_STD} "pthread.h")
if [ $? -eq 0 ];then
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_PTHREAD_H"
THIRDPARTY_ENABLE+=("HAVE_PTHREAD_H")
fi

(CheckHeader_C "${FAST_C_CXX_TARGET_COMPILER_C}" ${C_STD} "iconv.h") 
if [ $? -eq 0 ];then
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_ICONV_H"
THIRDPARTY_ENABLE+=("HAVE_ICONV_H")
fi

(CheckHeader_C "${FAST_C_CXX_TARGET_COMPILER_C}" ${C_STD} "linux/gpio.h") 
if [ $? -eq 0 ];then
EXTRA_C_FLAGS="${EXTRA_C_FLAGS} -DHAVE_GPIO_H"
THIRDPARTY_ENABLE+=("HAVE_GPIO_H")
fi

#
(CheckHeader_C "${FAST_C_CXX_TARGET_COMPILER_C}" ${C_STD} "omp.h") 
if [ $? -eq 0 ];then
EXTRA_C_FLAGS="${EXTRA_C_FLAGS}  -DHAVE_OPENMP -fopenmp"
EXTRA_LD_FLAGS="${EXTRA_LD_FLAGS} -fopenmp"
THIRDPARTY_ENABLE+=("HAVE_OPENMP")
fi