#!/bin/bash

# change "-DKDEPIM_SUPPORT_BUILD=FALSE" to  "-DKDEPIM_SUPPORT_BUILD=TRUE"
# if we have a kdepimlibs-framework package
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
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    -DLIB_INSTALL_DIR="lib${LIBDIRSUFFIX}" \
    -DLIBEXEC_INSTALL_DIR="lib${LIBDIRSUFFIX}" \
    -DQT_PLUGIN_INSTALL_DIR="lib${LIBDIRSUFFIX}/qt5/plugins" \
    -DQML_INSTALL_DIR="lib${LIBDIRSUFFIX}/qt5/qml" \
    -DBUILD_TESTING=OFF \
    -DKDEPIM_SUPPORT_BUILD=FALSE \
    ..
