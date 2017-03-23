#!/bin/bash

# separate cmake file for solid is needed to append "-std=c99" to the
# CMAKE_C_FLAGS, because of a bug in flex-2.6.0 which generates a C code
# with C++-style comments. The bug has been fixed in flex 2.6.1 which
# is not yet a part of Slackware 14.2
mkdir build
cd build || exit 1
cmake \
    "${KDE_OPT_ARGS}" \
    -DKDE_PLATFORM_FEATURE_DISABLE_DEPRECATED=TRUE \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS} -std=c99" \
    -DCMAKE_C_FLAGS_RELEASE:STRING="${SLKCFLAGS} -std=c99" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS_RELEASE:STRING="${SLKCFLAGS}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DMAN_INSTALL_DIR=/usr/man \
    -DSYSCONF_INSTALL_DIR=/etc/kde \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    -DLIB_INSTALL_DIR="lib${LIBDIRSUFFIX}" \
    -DLIBEXEC_INSTALL_DIR="lib${LIBDIRSUFFIX}" \
    -DQML_INSTALL_DIR="lib${LIBDIRSUFFIX}/qt5/qml" \
    -DQT_PLUGIN_INSTALL_DIR="lib${LIBDIRSUFFIX}/qt5/plugins" \
    -DKDE_INSTALL_USE_QT_SYS_PATHS=ON \
    -DAPPLICATIONS_MENU_NAME="kf5-applications.menu" \
    ..
