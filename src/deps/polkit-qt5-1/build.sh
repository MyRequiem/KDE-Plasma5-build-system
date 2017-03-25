#!/bin/sh

PKGNAME="polkit-qt5-1"

if [[ "${CHECK_PACKAGE_VERSION}" == "true" ]]; then
    echo -en "${GREY}Check ${CYAN}${PKGNAME}${GREY} latest version:${CDEF} "
    PKGNAMEQT4="$(echo "${PKGNAME}" | tr -d 5)"
    EXT=".tar.bz2"
    URL="https://download.kde.org/stable/apps/KDE4.x/admin/"
    VERSION=$(wget -q -O - "${URL}" | grep "<a href=\"${PKGNAMEQT4}-" | \
        grep "${EXT}\">" | cut -d \" -f 4 | rev | cut -d - -f 1 | \
        cut -d . -f 3- | rev | sort -V | tail -n 1)
    echo "${VERSION}"
    PKGVER="${PKGNAME}-${VERSION}"
    SOURCE="${PKGVER}.tar.xz"

    if ! [ -r "${SOURCE}" ]; then
        PKGQT4VER="${PKGNAMEQT4}-${VERSION}"
        SRCARCH="${PKGQT4VER}${EXT}"
        echo -e "${YELLOW}Downloading ${SRCARCH} source archive${CDEF}"
        wget "${URL}/${SRCARCH}"
        tar xf "${SRCARCH}" 1>/dev/null 2>&1
        rm -f "${SRCARCH}"
        mv "${PKGQT4VER}" "${PKGVER}"
        tar -cJf "${PKGVER}.tar.xz" "${PKGVER}" 1>/dev/null
        rm -rf "${PKGVER}"
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

# autodetects the Qt version to use, preferring Qt 5 over Qt 4.
# you can force a Qt 4 build passing -DUSE_QT4:bool=ON to CMake
mkdir -p build
cd build || exit 1
cmake \
    "${KDE_OPT_ARGS}" \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DMAN_INSTALL_DIR=/usr/man \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    ..

make "${NUMJOBS}" || make || exit 1
make install DESTDIR="${PKG}" || exit 1
cd .. || exit 1

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
