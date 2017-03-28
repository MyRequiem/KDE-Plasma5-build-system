#!/bin/bash

make_breeze() {
    make "${NUMJOBS}" || make || exit 1
    make install DESTDIR="${PKG}" || exit 1
}

# breeze's cmake left us in build_qt4, so we build and install Qt4 support first
make_breeze
# go back to build_qt5 and build/install the Qt5 support
cd ../build_qt5 || exit 1
make_breeze
