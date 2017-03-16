#!/bin/bash

# ============================== Settings ======================================
# KDE Frameworks 5 version
KF_VERSION="5.31.0"
# Plasma version
PLASMA_VERSION="5.9.3"
# KDE Applications version
KDE_APP_VERSION="16.12.2"
# temp directory for building packages
TEMP="/tmp/kde-plasma5-build"
# output for packages
OUTPUT="/root/src/kde-plasma5-packages"
# package extension
EXT="txz"
# tag for package
TAG="myreq"
# build package only if it is not in OUTPUT
BUILD_ONLY_NOT_EXIST="true"
# install package after build
INSTALL_AFTER_BUILD="false"
# check package version
CHECK_PACKAGE_VERSION="false"
# only download source code (without build)
ONLY_DOWNLOAD="false"
# ========================== End of settings ===================================


# if ONLY_DOWNLOAD == "true" variable CHECK_PACKAGE_VERSION must be set "true"
# and BUILD_ONLY_NOT_EXIST must be set "false"
[[ "${ONLY_DOWNLOAD}" == "true" ]] && CHECK_PACKAGE_VERSION="true" &&
    BUILD_ONLY_NOT_EXIST="false"

export KF_VERSION
export PLASMA_VERSION
export KDE_APP_VERSION
export TEMP
export OUTPUT
export EXT
export TAG
export BUILD_ONLY_NOT_EXIST
export INSTALL_AFTER_BUILD
export CHECK_PACKAGE_VERSION
export ONLY_DOWNLOAD
