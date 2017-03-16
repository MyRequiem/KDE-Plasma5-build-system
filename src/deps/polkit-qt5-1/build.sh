#!/bin/sh

PKGNAME="polkit-qt5-1"

if [[ "${CHECK_PACKAGE_VERSION}" == "true" ]]; then
    echo -en "${GREY}Check ${CYAN}${PKGNAME}${GREY} latest release:${CDEF} "
    PKGNAMEQT4="$(echo "${PKGNAME}" | tr -d 5)"
    rm -rf "${PKGNAMEQT4}"
    git clone "git://anongit.kde.org/${PKGNAMEQT4}" 1>/dev/null 2>&1
    cd "${PKGNAMEQT4}" || exit 1
    git checkout master 1>/dev/null 2>&1
    HEADHASH="$(git log -1 --format=%h)"
    DATE="$(git log -1 --format=%ad --date=format:%d%m%Y)"
    VERSION="${DATE}_${HEADHASH}"
    echo "${VERSION}"
    PKGVER="${PKGNAME}-${VERSION}"
    SOURCE="${PKGVER}.tar.xz"
    cd - || exit 1

    if ! [ -r "${SOURCE}" ]; then
        rm -rf "${PKGNAMEQT4}"/.git
        mv "${PKGNAMEQT4}" "${PKGVER}"
        tar -cJf "${PKGVER}".tar.xz "${PKGVER}" 1>/dev/null
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
cd - || exit 1

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
