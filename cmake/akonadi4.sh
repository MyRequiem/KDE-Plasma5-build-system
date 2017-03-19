#!/bin/bash

# if we do not specify the correct QT_PLUGINS_DIR, then the application
# decides on using $QT4DIR/qt4/plugins instead.
mkdir -p build
cd build || exit 1
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS}" \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DMAN_INSTALL_DIR=/usr/man \
    -DMAN_INSTALL_DIR=/usr/man \
    -DINSTALL_QSQLITE_IN_QT_PREFIX:BOOL=ON \
    -DQT_PLUGINS_DIR="/usr/lib${LIBDIRSUFFIX}/qt/plugins" \
    ..
