#!/bin/sh

PKGNAME="tidy-html5"

if [[ "${CHECK_PACKAGE_VERSION}" == "true" ]]; then
    echo -en "${GREY}Check ${CYAN}${PKGNAME}${GREY} latest release:${CDEF} "
    URL="https://github.com/htacg/${PKGNAME}"
    VERSION=$(wget -q -O - "${URL}/releases/" | \
        grep "<a href=\"/htacg/${PKGNAME}/releases/tag/" | head -n 1 | \
        cut -d \" -f 2 | rev | cut -d / -f 1 | rev)
    SOURCE="${PKGNAME}-${VERSION}.tar.gz"
    echo "${VERSION}"

    # download source archive if does not exist
    if ! [ -r "${SOURCE}" ]; then
        SRCNAME="${VERSION}.tar.gz"
        echo -e "${YELLOW}Downloading ${SRCNAME} source archive${CDEF}"
        wget "${URL}/archive/${SRCNAME}"
        mv "${SRCNAME}" "${SOURCE}"
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

cd build/cmake || exit 1
cmake \
    "${KDE_OPT_ARGS}" \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    -DMAN_INSTALL_DIR=/usr/man \
    ../..

make "${NUMJOBS}" || make || exit 1
make install DESTDIR="${PKG}" || exit 1
cd ../.. || exit 1

INCUDES="buffio.h platform.h"
for INCLUDE in ${INCUDES}; do
    cp "include/${INCLUDE}" "${PKG}/usr/include/"
done

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
