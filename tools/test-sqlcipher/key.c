// sample.c
//
// This file is part of SHELLKITS.
//
// Copyright (c) 2026 The SHELLKITS project authors. All Rights Reserved.
// Copyright (c) 2021 The ABCDK project authors. All Rights Reserved.
//
//
#include <stdio.h>

#ifndef SQLITE_HAS_CODEC
#define SQLITE_HAS_CODEC
#endif //SQLITE_HAS_CODEC
#include <sqlite3.h>
//
int main()
{
    sqlite3 *ctx = NULL;
    int chk = sqlite3_key(ctx,"123",3);
    return 0;
}
