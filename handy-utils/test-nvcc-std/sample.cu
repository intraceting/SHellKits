// sample.cu
//
// This file is part of SHELLKITS.
//
// Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
//
//
#include <iostream>

__global__ void hello_from_gpu()
{
    printf("test-nvcc!");
}

int main()
{
    hello_from_gpu<<<1, 1>>>();
    cudaDeviceSynchronize();
    return 0;
}
