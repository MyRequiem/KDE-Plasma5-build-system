#!/bin/sh

PKGNAME="lmdb"

if [[ "${CHECK_PACKAGE_VERSION}" == "true" ]]; then
    echo -en "${GREY}Check ${CYAN}${PKGNAME}${GREY} latest release:${CDEF} "
    URL="https://github.com/LMDB/lmdb"
    VERSION=$(wget -q -O - "${URL}/releases/" | \
        grep "<a href=\"/LMDB/lmdb/archive/" | grep ".tar.gz\"" | \
        cut -d \" -f 2 | rev | cut -d "_" -f 1 | cut -d . -f 3- | \
        rev | sort -V | tail -n 1)
    PKGVER="${PKGNAME}-${VERSION}"
    SOURCE="${PKGVER}.tar.xz"
    echo "${VERSION}"

    # download source archive if does not exist
    if ! [ -r "${SOURCE}" ]; then
        SRCNAME="LMDB_${VERSION}.tar.gz"
        echo -e "${YELLOW}Downloading ${SRCNAME} source archive${CDEF}"
        wget "${URL}/archive/${SRCNAME}"
        tar xvf "${SRCNAME}" 1>/dev/null 2>&1
        rm -f "${SRCNAME}"
        mv "${PKGNAME}-LMDB_${VERSION}" "${PKGVER}"
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

# fix a x86_64 installation issue
[[ "${ARCH}" == "x86_64" ]] &&
    sed -e "s,\$(exec_prefix)/lib,\$(exec_prefix)/lib${LIBDIRSUFFIX}," \
        -i libraries/liblmdb/Makefile

# compile:
cd "libraries/lib${PKGNAME}" || exit 1
make XCFLAGS="${SLKCFLAGS}" prefix="/usr"

# the 'make install' expects an existing directory structure:
mkdir -p "${PKG}/usr"/{bin,include,man/man1,lib"${LIBDIRSUFFIX}"}
make install prefix="/usr" DESTDIR="${PKG}"

. "${CWDD}"/additional-scripts/strip-binaries.sh
. "${CWDD}"/additional-scripts/copydocs.sh

SHAREMAN="${PKG}/usr/share/man"
if [ -d "${SHAREMAN}" ]; then
    rm -rf "${PKG}/usr/man"
    mv "${SHAREMAN}" "${PKG}/usr/"
    . "${CWDD}"/additional-scripts/compressmanpages.sh
fi

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
