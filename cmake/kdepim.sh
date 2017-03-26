#!/bin/bash

mkdir build
cd build || exit 1
cmake \
    "${KDE_OPT_ARGS}" \
    -DKDE_PLATFORM_FEATURE_DISABLE_DEPRECATED=TRUE \
    -DCMAKE_C_FLAGS:STRING="-I/usr/include/grantlee-qt5 ${SLKCFLAGS}" \
    -DCMAKE_C_FLAGS_RELEASE:STRING="-I/usr/include/grantlee-qt5 ${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS:STRING="-I/usr/include/grantlee-qt5 ${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS_RELEASE:STRING="-I/usr/include/grantlee-qt5 ${SLKCFLAGS}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DMAN_INSTALL_DIR=/usr/man \
    -DSYSCONF_INSTALL_DIR=/etc/kde \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    -DLIB_INSTALL_DIR="lib${LIBDIRSUFFIX}" \
    -DLIBEXEC_INSTALL_DIR="lib${LIBDIRSUFFIX}" \
    -DQT_PLUGIN_INSTALL_DIR="lib${LIBDIRSUFFIX}/qt5/plugins" \
    -DQML_INSTALL_DIR="lib${LIBDIRSUFFIX}/qt5/qml" \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DBUILD_TESTING=OFF \
    -DQca-qt5_DIR="/usr/lib${LIBDIRSUFFIX}/cmake/Qca" \
    ..
