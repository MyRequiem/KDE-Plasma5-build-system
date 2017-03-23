#!/bin/bash

# ============================== Settings ======================================
# OS version
SLACKWAREVER="14.2"
# main KDE URL for downloading source
KDEDOWNLOAD="https://download.kde.org/stable"
# KDE4 version in KDEDOWNLOAD page
KDE4VERSION="4.14.3"
# KDE Frameworks 5 version
KF_VERSION="5.32.0"
# Plasma version
PLASMA_VERSION="5.9.3"
# KDE Applications version
KDE_APP_VERSION="16.12.3"
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
CHECK_PACKAGE_VERSION="true"
# only download source code (without build)
ONLY_DOWNLOAD="false"
# ========================== End of settings ===================================


# if ONLY_DOWNLOAD == "true" variable CHECK_PACKAGE_VERSION must be set "true"
# and BUILD_ONLY_NOT_EXIST must be set "false"
[[ "${ONLY_DOWNLOAD}" == "true" ]] && CHECK_PACKAGE_VERSION="true" &&
    BUILD_ONLY_NOT_EXIST="false"

export SLACKWAREVER
export KDEDOWNLOAD
export KDE4VERSION
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
