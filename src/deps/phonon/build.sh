#!/bin/sh

PKGNAME="phonon"

if [[ "${CHECK_PACKAGE_VERSION}" == "true" ]]; then
    echo -en "${GREY}Check ${CYAN}${PKGNAME}${GREY} latest release:${CDEF} "
    URL="https://download.kde.org/stable/phonon/"
    VERSION=$(wget -q -O - "${URL}" | grep "<a href=" | \
        grep -E '>([0-9]|\.)+\/<' | cut -d \" -f 4 | tr -d / | sort -V | \
        tail -n 1)
    SOURCE="${PKGNAME}-${VERSION}.tar.xz"
    echo "${VERSION}"

    # download source archive if does not exist
    if ! [ -r "${SOURCE}" ]; then
        echo -e "${YELLOW}Downloading ${SOURCE} source archive${CDEF}"
        wget "${URL}${VERSION}/${SOURCE}"
    fi
else
    SOURCE=$(find . -type f -name "${PKGNAME}-[0-9]*.tar.?z*" | head -n 1 | \
        rev | cut -d / -f 1 | rev)
    VERSION=$(echo "${SOURCE}" | rev | cut -d - -f 1 | cut -d . -f 3- | rev)
fi

[[ "${ONLY_DOWNLOAD}" == "true" ]] && exit 0

CWD=$(pwd)
TMP="${TEMP}/deps"
PKG="${TMP}/package-${PKGNAME}"

rm -rf "${PKG}"
mkdir -p "${PKG}"
cd "${TMP}" || exit 1
rm -rf "${PKGNAME}-${VERSION}"
tar xvf "${CWD}/${SOURCE}"
cd "${PKGNAME}-${VERSION}" || exit 1
. "${CWDD}"/additional-scripts/setperm.sh

if pkg-config --exists libpulse 2>/dev/null ; then
    DOPULSE="ON"
else
    DOPULSE="OFF"
fi

mkdir build
cd build || exit
QTPLUGINS="/usr/lib${LIBDIRSUFFIX}/qt/plugins/designer"
cmake \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DMAN_INSTALL_DIR=/usr/man \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    -DPHONON_INSTALL_QT_EXTENSIONS_INTO_SYSTEM_QT:BOOL=ON \
    -DPHONON_QT_PLUGIN_INSTALL_DIR="${QTPLUGINS}" \
    -DWITH_QZeitgeist=BOOL:OFF \
    -DWITH_PulseAudio=BOOL:${DOPULSE} \
    ..

make "${NUMJOBS}" || make || exit 1
make install DESTDIR="${PKG}" || exit 1
cd .. || exit 1

# Qt5 support:
if qtpaths-qt5 --qt-version 1>/dev/null 2>/dev/null; then
    mkdir build-qt5
    cd build-qt5 || exit 1
    cmake \
        -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS}" \
        -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS}" \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DMAN_INSTALL_DIR=/usr/man \
        -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
        -DPHONON_INSTALL_QT_EXTENSIONS_INTO_SYSTEM_QT:BOOL=ON \
        -DPHONON_QT_PLUGIN_INSTALL_DIR="${QTPLUGINS}" \
        -DWITH_QZeitgeist=BOOL:OFF \
        -DWITH_PulseAudio=BOOL:${DOPULSE} \
        -DPHONON_BUILD_PHONON4QT5=ON \
        -D__KDE_HAVE_GCC_VISIBILITY=NO \
        -DQT_QMAKE_EXECUTABLE=/usr/bin/qmake-qt5 \
        ..

    make "${NUMJOBS}" || make || exit 1
    make install DESTDIR="${PKG}" || exit 1
    cd .. || exit 1
fi

# PyQT won't find the header files otherwise:
sed -i -e 's#{includedir}$#& -I\${includedir}/phonon#' \
    "${PKG}/usr/lib${LIBDIRSUFFIX}/pkgconfig/phonon.pc"

. "${CWDD}"/additional-scripts/strip-binaries.sh
. "${CWDD}"/additional-scripts/copydocs.sh
. "${CWDD}"/additional-scripts/compressmanpages.sh

mkdir -p "${PKG}/install"
cat "${CWD}/slack-desc" > "${PKG}/install/slack-desc"

cd "${PKG}" || exit 1
mkdir -p "${OUTPUT}/deps"
BUILD=$(cat "${CWDD}/build/${PKGNAME}" 2>/dev/null || echo "1")
PKG="${OUTPUT}/deps/${PKGNAME}-${VERSION}-${ARCH}-${BUILD}_${TAG}.${EXT}"
rm -f "${PKG}"
makepkg -l y -c n "${PKG}"

if [[ "${INSTALL_AFTER_BUILD}" == "true" ]]; then
    upgradepkg --install-new --reinstall "${PKG}"
fi
