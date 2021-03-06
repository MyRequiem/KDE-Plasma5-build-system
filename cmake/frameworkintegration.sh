#!/bin/bash

# workaround a bug in Qt 5.5.0 which makes OwnCloud crash when interacting
# with the systray menu (and possibly other applications too)
# by adding "-fno-strict-aliasing" to CFLAGS and CXXFLAGS
# http://bugzilla.redhat.com/1255902
# https://bugreports.qt.io/browse/QTBUG-47863
mkdir build
cd build || exit 1
cmake \
    "${KDE_OPT_ARGS}" \
    -DKDE_PLATFORM_FEATURE_DISABLE_DEPRECATED=TRUE \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS} -fno-strict-aliasing" \
    -DCMAKE_C_FLAGS_RELEASE:STRING="${SLKCFLAGS} -fno-strict-aliasing" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS} -fno-strict-aliasing" \
    -DCMAKE_CXX_FLAGS_RELEASE:STRING="${SLKCFLAGS} -fno-strict-aliasing" \
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
    -Dlconvert_executable="/usr/lib${LIBDIRSUFFIX}/qt5/bin/lconvert" \
    ..
