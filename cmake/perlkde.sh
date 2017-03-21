#!/bin/bash

# set "vendorarch" (install location for vendor shipped
# architecture dependent perl modules)
VENDORARCH="$(perl '-V:vendorarch' | cut -d \' -f 2)"

mkdir -p build
cd build || exit 1
cmake \
    "${KDE_OPT_ARGS}" \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_C_FLAGS_RELEASE:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS_RELEASE:STRING="${SLKCFLAGS}" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DMAN_INSTALL_DIR=/usr/man \
    -DCUSTOM_PERL_SITE_ARCH_DIR="${VENDORARCH}" \
    -DSYSCONF_INSTALL_DIR=/etc/kde \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    ..
