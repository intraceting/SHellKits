#!/bin/bash
#
# This file is part of SHELLKITS.
#  
# Copyright (c) 2025 The SHELLKITS project authors. All Rights Reserved.
# Copyright (c) 2021 The ABCDK project authors. All Rights Reserved.
# 
##

#
SHELLDIR=$(cd `dirname "$0"`; pwd)

# Functions
checkReturnCode()
{
    rc=$?
    if [ $rc != 0 ];then
        exit $rc
    fi
}

#
CheckSystemName()
# $1 System Name
{
    ${SHELLDIR}/../../tools/check-os-id.sh "$1"
}

#
GetSystemVersion()
{
    ${SHELLDIR}/../../tools/get-os-ver.sh
}

#
CheckPackageKitName()
{
	${SHELLDIR}/../../tools/get-kit-name.sh
}

#
CheckHavePackageFromKit()
# $1 PACKAGE
{
    ${SHELLDIR}/../../tools/check-package.sh "$1"
}

#
CheckHavePackageFromWhich()
# $1 PACKAGE
{
	${SHELLDIR}/../../tools/check-which.sh "$1"
}

#
FindBinPath()
# $1 HDNAME
{
	${SHELLDIR}/../../tools/find-bin-path.sh "$1"
}

#
FindIncPath()
# $1 HDNAME
{
	${SHELLDIR}/../../tools/find-inc-path.sh "$1"
}

#
FindLibPath()
# $1 SONAME
{
	${SHELLDIR}/../../tools/find-lib-path.sh "$1"
}

#
PackageConfig()
# $1 SONAME
{
	${SHELLDIR}/../../tools/pkg-config.sh $@
}


#
if [ $# -lt 1 ];then
exit 22
fi

#
SYS_VERID=$(GetSystemVersion)
KIT_NAME=$(CheckPackageKitName)
FLAG="$1"
   
#
if [ "deb" == "${KIT_NAME}" ];then 
{ 
    if [ ${FLAG} -eq 1 ];then
        exit $(CheckHavePackageFromKit cuda-dev)
    elif [ ${FLAG} -eq 2 ];then
    {
        INC_PATH="$(FindIncPath cuda.h)"
        checkReturnCode

        echo "-I${INC_PATH}"
    }
    elif [ ${FLAG} -eq 3 ];then
    {
        LIB_PATH="$(FindLibPath cudart)"
        checkReturnCode

        echo "-lcublasLt -lcublas -lcudart -lnppig -lnppc -lnppial -lnppicc -lnppidei -lnppif -lnppim -lnppisu -lnpps -lnvjpeg -lcuda -L${LIB_PATH} -L${LIB_PATH}/stubs"
    }
    elif [ ${FLAG} -eq 4 ];then
        echo "cuda-dev"
    elif [ ${FLAG} -eq 5 ];then
    {
        BIN_PATH="$(FindBinPath nvcc)"
        checkReturnCode

        echo "${BIN_PATH}/nvcc"
    }
    else
        exit 22
    fi
}
elif [ "rpm" == "${KIT_NAME}" ];then 
{
    if [ ${FLAG} -eq 1 ];then
        exit $(CheckHavePackageFromKit cuda-devel)
    elif [ ${FLAG} -eq 2 ];then
    {
        INC_PATH="$(FindIncPath cuda.h)"
        checkReturnCode

        echo "-I${INC_PATH}"
    }
    elif [ ${FLAG} -eq 3 ];then
    {
        LIB_PATH="$(FindLibPath cudart)"
        checkReturnCode

        echo "-lcublasLt -lcublas -lcudart -lnppig -lnppc -lnppial -lnppicc -lnppidei -lnppif -lnppim -lnppisu -lnpps -lnvjpeg -lcuda -L${LIB_PATH} -L${LIB_PATH}/stubs"
    }
    elif [ ${FLAG} -eq 4 ];then
        echo "cuda-devel"
    elif [ ${FLAG} -eq 5 ];then
    {
        BIN_PATH="$(FindBinPath nvcc)"
        checkReturnCode

        echo "${BIN_PATH}/nvcc"
    }
    else
        exit 22
    fi
}
else
{
    exit 1
}
fi 

#
exit $?
