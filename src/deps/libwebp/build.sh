#!/bin/sh

PKGNAME="libwebp"

if [[ "${CHECK_PACKAGE_VERSION}" == "true" ]]; then
    echo -en "${GREY}Check ${CYAN}${PKGNAME}${GREY} latest release:${CDEF} "
    URL="https://github.com/webmproject/libwebp"
    VERSION="$(wget -q -O - "${URL}/releases" | grep "/releases/tag/v" | \
        grep -v "\-rc" | head -n 1 | rev | cut -d \" -f 2 | \
        cut -d "v" -f 1 | rev)"
    echo "${VERSION}"
    SOURCE="${PKGNAME}-${VERSION}.tar.xz"

    # download source archive if does not exist
    if ! [ -r "${SOURCE}" ]; then
        ARCHNAME="v${VERSION}.tar.gz"
        echo -e "${YELLOW}Downloading ${ARCHNAME} source archive${CDEF}"
        wget "${URL}/archive/${ARCHNAME}"
        mv "${ARCHNAME}" "${SOURCE}"
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

[ -x autogen.sh ] && ./autogen.sh

CFLAGS="${SLKCFLAGS}" \
CXXFLAGS="${SLKCFLAGS}" \
./configure \
    --prefix=/usr \
    --libdir="/usr/lib${LIBDIRSUFFIX}" \
    --sysconfdir=/etc \
    --localstatedir=/var \
    --mandir=/usr/man \
    --disable-static \
    --disable-silent-rules \
    --enable-everything \
    --enable-swap-16bit-csp \
    --enable-experimental \
    --build="${ARCH}-slackware-linux"

make "${NUMJOBS}" || make || exit 1
make install DESTDIR="${PKG}" || exit 1

. "${CWDD}"/additional-scripts/strip-binaries.sh
. "${CWDD}"/additional-scripts/copydocs.sh
. "${CWDD}"/additional-scripts/compressmanpages.sh


(
    cd swig || exit 1
    # fix temporary working directory
    sed -i "/^tmpdir/s|=.*|= 'tmpdir'|" setup.py
    CFLAGS="${SLKCFLAGS} -I${PKG}/usr/include" \
    LDFLAGS="-L${PKG}/usr/lib${LIBDIRSUFFIX} -lwebp" \
    python setup.py install --root="${PKG}"
    # install the python3 module if python3 is installed
    if python3 -c 'import sys' 2>/dev/null; then
        CFLAGS="$SLKCFLAGS -I$PKG/usr/include" \
        LDFLAGS="-L$PKG/usr/lib${LIBDIRSUFFIX} -lwebp" \
        python3 setup.py install --root="${PKG}"
    fi
)

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
