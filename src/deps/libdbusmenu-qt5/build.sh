#!/bin/sh

PKGNAME="libdbusmenu-qt5"

if [[ "${CHECK_PACKAGE_VERSION}" == "true" ]]; then
    echo -en "${GREY}Check ${CYAN}${PKGNAME}${GREY} latest version:${CDEF} "
    PKGNAMEQT4="$(echo "${PKGNAME}" | tr -d 5)"
    rm -rf "${PKGNAMEQT4}"
    bzr branch lp:"${PKGNAMEQT4}" 1>/dev/null 2>&1
    cd "${PKGNAMEQT4}" || exit 1
    REVISION="$(bzr log | grep revno | head -n 1 | cut -d " " -f 2)"
    DATE="$(bzr log | grep timestamp | head -n 1 | cut -d " " -f 3 | tr -d -)"
    VERSION="${REVISION}_${DATE}"
    echo "${VERSION}"
    PKGVER="${PKGNAME}-${VERSION}"
    SOURCE="${PKGVER}.tar.xz"
    cd .. || exit 1

    if ! [ -r "${SOURCE}" ]; then
        echo -e "${YELLOW}Create ${PKGVER}.tar.xz ...${CDEF}"
        rm -rf "${PKGNAMEQT4}"/.bzr*
        mv "${PKGNAMEQT4}" "${PKGVER}"
        tar -cJf "${PKGVER}.tar.xz" "${PKGVER}" 1>/dev/null
        rm -rf "${PKGVER}"
    else
        rm -rf "${PKGNAMEQT4}"
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
