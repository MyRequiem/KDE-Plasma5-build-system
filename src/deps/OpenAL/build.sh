#!/bin/sh

PKGNAME="OpenAL"

if [[ "${CHECK_PACKAGE_VERSION}" == "true" ]]; then
    echo -en "${GREY}Check ${CYAN}${PKGNAME}${GREY} latest release:${CDEF} "
    EXT=".tar.bz2"
    SRCPKGNAME="openal-soft"
    URL="http://kcat.strangesoft.net/openal-releases/"
    VERSION=$(wget -q -O - "${URL}" | grep "<a href=\"${SRCPKGNAME}" | \
        grep "${EXT}" | cut -d \" -f 8 | rev | cut -d - -f 1 | \
        cut -d . -f 3- | rev | sort -V | tail -n 1)
    SOURCEVER="${PKGNAME}-${VERSION}"
    SOURCE="${SOURCEVER}.tar.xz"
    echo "${VERSION}"

    # download source archive if does not exist
    if ! [ -r "${SOURCE}" ]; then
        SRCVER="${SRCPKGNAME}-${VERSION}"
        SRCNAME="${SRCVER}${EXT}"
        echo -e "${YELLOW}Downloading ${SRCNAME} source archive${CDEF}"
        wget "${URL}${SRCNAME}"
        tar xvf "${SRCNAME}" 1>/dev/null 2>&1
        mv "${SRCVER}" "${SOURCEVER}"
        rm -f "${SRCNAME}"
        tar -cJf "${SOURCE}" "${SOURCEVER}" 1>/dev/null
        rm -rf "${SOURCEVER}"
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
cmake \
    -DCMAKE_C_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_CXX_FLAGS:STRING="${SLKCFLAGS}" \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DMAN_INSTALL_DIR=/usr/man \
    -DSYSCONF_INSTALL_DIR=/etc \
    -DLIB_SUFFIX="${LIBDIRSUFFIX}" \
    ..

make "${NUMJOBS}" || make || exit 1
make install DESTDIR="${PKG}" || exit 1
cd .. || exit 1

# add an example configuration file
ETCOPENAL="${PKG}/etc/openal"
mkdir -p "${ETCOPENAL}"
install -m0644 alsoftrc.sample "${ETCOPENAL}/alsoft.conf.sample"

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

if [[ "${INSTALL_AFTER_BUILD}" == "true" ]]; then
    upgradepkg --install-new --reinstall "${PKG}"
fi
