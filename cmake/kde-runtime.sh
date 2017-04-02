#!/bin/bash

# "-std=c++11" is required for gpgme-1.7+ for std::shared_ptr support
mkdir build
cd build || exit 1
cmake \
    "${KDE_OPT_ARGS}" \
    -DKDE_PLATFORM_FEATURE_DISABLE_DEPRECATED=TRUE \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS} -std=c++11" \
    -DCMAKE_C_FLAGS_RELEASE:STRING="${SLKCFLAGS} -std=c++11" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS} -std=c++11" \
    -DCMAKE_CXX_FLAGS_RELEASE:STRING="${SLKCFLAGS} -std=c++11" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DMAN_INSTALL_DIR=/usr/man \
    -DSYSCONF_INSTALL_DIR=/etc/kde \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    -DBUILD_khelpcenter=OFF \
    -DBUILD_kglobalaccel=OFF \
    -DBUILD_kuiserver=OFF \
    ..
