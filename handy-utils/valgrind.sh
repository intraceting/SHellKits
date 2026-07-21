#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# 
# 
#
SHELLDIR=$(cd `dirname $0`; pwd)

#在VSCODE环境中，把当前脚本的路径作为"miDebuggerPath"字段的值。
#例："miDebuggerPath": "${workspaceFolder}/tools/valgrind.sh",

#
#set -x

#
/usr/bin/valgrind --leak-check=full --show-leak-kinds=all $@

#
#set +x