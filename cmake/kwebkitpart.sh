#!/bin/bash

mkdir -p build
cd build || exit 1

PATH="${QTDIR}/bin:${PATH}"
cmake \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    ..
