#!/bin/sh

PKGNAME="libdbusmenu-qt5"

if [[ "${CHECK_PACKAGE_VERSION}" == "true" ]]; then
    echo -en "${GREY}Check ${CYAN}${PKGNAME}${GREY} latest version:${CDEF} "
    URL="http://bear.alienbase.nl/mirrors/alien-kde/source/testing/deps"
    URL="${URL}/${PKGNAME}/"
    VERSION=$(wget -q -O - ${URL} | grep "href=\"${PKGNAME}" | \
        grep ".tar.xz\"" | cut -d \" -f 8 | cut -d - -f 3 | rev | \
        cut -d . -f 3- | rev)
    echo "${VERSION}"
    SOURCE="${PKGNAME}-${VERSION}.tar.xz"

    # download source archive if does not exist
    if ! [ -r "${SOURCE}" ]; then
        echo -e "${YELLOW}Downloading ${SOURCE} source archive${CDEF}"
        wget "${URL}${SOURCE}"
    fi
else
    SOURCE=$(find . -type f -name "${PKGNAME}-*.tar.?z*" | head -n 1 | \
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

mkdir -p build
cd build || exit 1
PTH="${PATH}"
export QTDIR="/usr/lib${LIBDIRSUFFIX}/qt5"
export PATH="${QTDIR}/bin:${PATH}"
cmake \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    -DUSE_QT4:BOOL=FALSE \
    -DUSE_QT5:BOOL=TRUE \
    ..

make "${NUMJOBS}" || make || exit 1
make install DESTDIR="${PKG}" || exit 1
cd .. || exit 1

. "${CWDD}"/additional-scripts/strip-binaries.sh
. "${CWDD}"/additional-scripts/copydocs.sh

DOCS="${PKG}/usr/doc/${PKGNAME}-${VERSION}"
[ -d "${DOCS}/${PKGNAME}-doc" ] && mv "${DOCS}/${PKGNAME}-doc" "${DOCS}/html"

mkdir -p "${PKG}/install"
cat "${CWD}/slack-desc" > "${PKG}/install/slack-desc"

cd "${PKG}" || exit 1
mkdir -p "${OUTPUT}/deps"
BUILD=$(cat "${CWDD}/build/${PKGNAME}" 2>/dev/null || echo "1")
PKG="${OUTPUT}/deps/${PKGNAME}-${VERSION}-${ARCH}-${BUILD}_${TAG}.${EXT}"
rm -f "${PKG}"
makepkg -l y -c n "${PKG}"

export QTDIR="/usr/lib${LIBDIRSUFFIX}/qt"
PATH="${PTH}"
export PATH

if [[ "${INSTALL_AFTER_BUILD}" == "true" ]]; then
    upgradepkg --install-new --reinstall "${PKG}"
fi
