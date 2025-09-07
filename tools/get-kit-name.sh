#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# Copyright (c) 2021 The ABCDK project authors. All Rights Reserved.
# 
##
#
SHELLDIR=$(cd `dirname $0`; pwd)

#
if [ $(${SHELLDIR}/check-os-id.sh "Ubuntu|Debian") -ge 1 ];then
	echo "deb"
elif [ $(${SHELLDIR}/check-os-id.sh "CentOS|Red Hat|RedHat|RHEL|fedora|Amazon|amzn|Oracle|rocky") -ge 1 ];then
	echo "rpm"
else
	echo ""
fi