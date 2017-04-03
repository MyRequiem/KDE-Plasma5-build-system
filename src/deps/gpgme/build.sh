#!/bin/sh

PKGNAME="gpgme"

if [[ "${CHECK_PACKAGE_VERSION}" == "true" ]]; then
    echo -en "${GREY}Check ${CYAN}${PKGNAME}${GREY} latest release:${CDEF} "
    URL="https://www.gnupg.org/ftp/gcrypt/gpgme/"
    VERSION=$(wget -q -O - "${URL}" | grep "<a href=\"${PKGNAME}" | \
        grep ".tar.bz2\">" | cut -d \" -f 4 | rev | cut -d - -f 1 | \
        cut -d . -f 3- | rev | sort -V | tail -n 1)
    SOURCE="${PKGNAME}-${VERSION}.tar.bz2"
    echo "${VERSION}"

    # download source archive if does not exist
    if ! [ -r "${SOURCE}" ]; then
        echo -e "${YELLOW}Downloading ${SOURCE} source archive${CDEF}"
        wget "${URL}${SOURCE}"
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

if [[ "${VERSION}" == "1.8.0" ]]; then
    zcat "${CWD}/patches/gpgme-1.8.0_libsuffix.patch.gz" | \
        patch -p1 --verbose || exit 1
    zcat "${CWD}/patches/gpgme-1.8.0-headers-path.patch.gz" | \
        patch -p1 --verbose || exit 1
fi

CFLAGS="${SLKCFLAGS}" \
CXXFLAGS="${SLKCFLAGS}" \
./configure \
    --prefix=/usr \
    --libdir="/usr/lib${LIBDIRSUFFIX}" \
    --sysconfdir=/etc \
    --infodir=/usr/info \
    --docdir="/usr/doc/${PKGNAME}-${VERSION}" \
    --enable-languages="cl cpp python2 qt" \
    --build="${ARCH}-slackware-linux" \
    --host="${ARCH}-slackware-linux"

make "${NUMJOBS}" || make || exit 1
make install DESTDIR="${PKG}" || exit 1

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
