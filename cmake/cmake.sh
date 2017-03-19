#!/bin/bash

mkdir build
cd build || exit 1
cmake \
    "${KDE_OPT_ARGS}" \
    -DKDE_PLATFORM_FEATURE_DISABLE_DEPRECATED=TRUE \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_C_FLAGS_RELEASE:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS_RELEASE:STRING="${SLKCFLAGS}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DMAN_INSTALL_DIR=/usr/man \
    -DSYSCONF_INSTALL_DIR=/etc/kde \
    -DLIB_INSTALL_DIR="/usr/lib${LIBDIRSUFFIX}" \
    -DLIBEXEC_INSTALL_DIR="/usr/lib${LIBDIRSUFFIX}" \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    ..
