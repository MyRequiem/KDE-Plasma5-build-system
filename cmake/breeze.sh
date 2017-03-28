#!/bin/bash

# first configure the Qt5 support:
mkdir build_qt5
cd build_qt5 || exit 1
cmake \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_C_FLAGS_RELEASE:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS_RELEASE:STRING="${SLKCFLAGS}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DMAN_INSTALL_DIR=/usr/man \
    -DSYSCONF_INSTALL_DIR=/etc/kde \
    -DBUILD_TESTING=OFF \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    -DLIB_INSTALL_DIR="lib${LIBDIRSUFFIX}" \
    -DLIBEXEC_INSTALL_DIR="lib${LIBDIRSUFFIX}" \
    -DQT_PLUGIN_INSTALL_DIR="lib${LIBDIRSUFFIX}/qt5/plugins" \
    -DQML_INSTALL_DIR="lib${LIBDIRSUFFIX}/qt5/qml" \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    ..

# next, the Qt4 integration:
mkdir ../build_qt4
cd ../build_qt4 || exit
cmake \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_C_FLAGS_RELEASE:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS_RELEASE:STRING="${SLKCFLAGS}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DMAN_INSTALL_DIR=/usr/man \
    -DSYSCONF_INSTALL_DIR=/etc/kde \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    -DBUILD_TESTING=OFF \
    -DUSE_KDE4=ON \
    ..
