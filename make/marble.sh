#!/bin/bash

make_install() {
    make "${NUMJOBS}" || make || exit 1
    make install DESTDIR="${PKG}" || exit 1
}

# marble cmake left us in build_qt4, so we build and install Qt4 support first
make_install

# rename the marble4 include dir to avoid a conflict with marble and fix that
# include path in the cmake file too
mv "${PKG}/usr/include"/marble{,4}

# move the marble4 cmake file so that it will be found
FINDMARBLE="${PKG}/usr/share/marble/cmake/FindMarble.cmake"
if [ -f "${FINDMARBLE}" ]; then
    CMAKEMODULES="${PKG}/usr/share/apps/cmake/modules"
    mkdir -p "${CMAKEMODULES}"
    mv "${FINDMARBLE}" "${CMAKEMODULES}"

    sed -i "${CMAKEMODULES}/FindMarble.cmake" \
        -e 's,marble/MarbleModel.h,marble4/MarbleModel.h,'
fi

# build/install the Qt5 support
cd ../build_qt5 || exit 1
# fix installation of the designer plugins - only a problem for the Qt5 libs
sed  -i ../CMakeLists.txt -e 's,LIB_SUFFIX}/plugins,LIB_SUFFIX}/qt5/plugins,g'
make_install
