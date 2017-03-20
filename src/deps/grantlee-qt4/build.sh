#!/bin/sh

PKGNAME="grantlee-qt4"

if [[ "${CHECK_PACKAGE_VERSION}" == "true" ]]; then
    echo -en "${GREY}Check ${CYAN}${PKGNAME}${GREY} latest release:${CDEF} "
    URL="https://github.com/steveire/grantlee"
    VERSION=$(wget -q -O - "${URL}/releases/" | \
        grep "<a href=\"/steveire/grantlee/archive/" | grep ".tar.gz\"" | \
        grep -v "\-rc" | grep -v v5 | cut -d \" -f 2 | rev | cut -d "v" -f 1 | \
        cut -d . -f 3- | rev | sort -V | tail -n 1)
    SOURCE="${PKGNAME}-${VERSION}.tar.xz"
    echo "${VERSION}"

    # download source archive if does not exist
    if ! [ -r "${SOURCE}" ]; then
        SRCNAME="v${VERSION}.tar.gz"
        echo -e "${YELLOW}Downloading ${SRCNAME} source archive${CDEF}"
        wget "${URL}/archive/${SRCNAME}"
        echo -e "${YELLOW}Creating ${SOURCE} source archive${CDEF}"
        tar xvf "${SRCNAME}" 1>/dev/null 2>&1
        rm -f "${SRCNAME}"
        PKGSOURCE="$(basename "${SOURCE}" .tar.xz)"
        ARCHPKGNAME="$(echo "${PKGNAME}" | cut -d - -f 1)"
        mv "${ARCHPKGNAME}-${VERSION}" "${PKGSOURCE}"
        tar -cJf "${SOURCE}" "${PKGSOURCE}" 1>/dev/null
        rm -rf "${PKGSOURCE}"
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

# make sure this package does not clash with Qt5 based grantlee
sed  -i CMakeLists.txt \
    -e 's|INCLUDE_INSTALL_DIR include|INCLUDE_INSTALL_DIR include/grantlee-qt4|'

PTH="${PATH}"
PATH="${QTDIR}/bin:${PATH}"
export PATH

mkdir -p build
cd build || exit 1
cmake \
    "${KDE_OPT_ARGS}" \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    ..

make "${NUMJOBS}" || make || exit 1
make install DESTDIR="${PKG}" || exit 1
cd .. || exit 1

. "${CWDD}"/additional-scripts/strip-binaries.sh
. "${CWDD}"/additional-scripts/copydocs.sh

mkdir -p "${PKG}/install"
cat "${CWD}/slack-desc" > "${PKG}/install/slack-desc"

cd "${PKG}" || exit 1
mkdir -p "${OUTPUT}/deps"
BUILD=$(cat "${CWDD}/build/${PKGNAME}" 2>/dev/null || echo "1")
PKG="${OUTPUT}/deps/${PKGNAME}-${VERSION}-${ARCH}-${BUILD}_${TAG}.${EXT}"
rm -f "${PKG}"
makepkg -l y -c n "${PKG}"

PATH="${PTH}"
export PATH

if [[ "${INSTALL_AFTER_BUILD}" == "true" ]]; then
    upgradepkg --install-new --reinstall "${PKG}"
fi
