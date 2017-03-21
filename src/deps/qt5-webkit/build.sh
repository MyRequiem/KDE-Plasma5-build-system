#!/bin/sh

# From http://bear.alienbase.nl/mirrors/alien-kde/source/5/deps/qt5-webkit/
# The original script qt5-webkit.SlackBuild is located in this directory.

PKGNAME="qt5-webkit"
VERSION="5.7.1"
SOURCE="qtwebkit-opensource-src-${VERSION}.tar.xz"

if [[ "${CHECK_PACKAGE_VERSION}" == "true" ]]; then
    # download source archive if does not exist
    if ! [ -r "${SOURCE}" ]; then
        echo -e "${YELLOW}Downloading ${SOURCE} source archive${CDEF}"
        DOWNLOAD="http://bear.alienbase.nl/mirrors/alien-kde"
        DOWNLOAD="${DOWNLOAD}/source/5/deps/${PKGNAME}/${SOURCE}"
        wget "${DOWNLOAD}"
    fi
fi

[[ "${ONLY_DOWNLOAD}" == "true" ]] && exit 0

CWD=$(pwd)
TMP="${TEMP}/deps"
PKG="${TMP}/package-${PKGNAME}"

rm -rf "${PKG}"
mkdir -p "${PKG}"
cd "${TMP}" || exit 1
UNPACKSRCDIR="$(basename "${SOURCE}" .tar.xz)"
echo "Removing old ${TMP}/${UNPACKSRCDIR} directory ..."
rm -rf "${UNPACKSRCDIR}"
echo "Unpacking archive ${SOURCE} into ${TMP} ..."
tar xf "${CWD}/${SOURCE}"
cd "${UNPACKSRCDIR}" || exit 1
echo "Set owner and permissions into ${TMP}/${UNPACKSRCDIR} ..."
. "${CWDD}"/additional-scripts/setperm.sh

export RELOCATIONS="-reduce-relocations"
export CFLAGS="${SLKCFLAGS}"
export CXXFLAGS="${SLKCFLAGS}"
export OPENSOURCE_CXXFLAGS="${SLKCFLAGS}"
QTD="${QTDIR}"
export QTDIR="/usr/lib${LIBDIRSUFFIX}/qt5"
LDLP="${LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH="${QTDIR}/qtbase/lib:${QTDIR}/qttools/lib:${LDLP}"

mkdir build
cd build || exit 1
qmake-qt5 ..
make "${NUMJOBS}" || make || exit 1
make install INSTALL_ROOT="${PKG}" || exit 1
cd .. || exit 1

. "${CWDD}"/additional-scripts/strip-binaries.sh
. "${CWDD}"/additional-scripts/copydocs.sh

# fix internal linking for Qt5WebKit.pc , thanks to Larry Hajali's SBo script:
sed -i \
    -e "s|-Wl,-whole-archive -lWebKit1 -Wl,-no-whole-archive -L${PWD}/qtwebkit/Source/WebKit[^ ]* ||" \
    -e "s|-Wl,-whole-archive -lWebKit2 -Wl,-no-whole-archive -L${PWD}/qtwebkit/Source/WebKit2[^ ]* ||" \
    -e "s|-Wl,-whole-archive -lWebCore -Wl,-no-whole-archive -L${PWD}/qtwebkit/Source/WebCore[^ ]* ||" \
    -e "s|-Wl,-whole-archive -lANGLE -Wl,-no-whole-archive -L${PWD}/qtwebkit/Source/ThirdParty/ANGLE[^ ]* ||" \
    -e "s|-Wl,-whole-archive -lJavaScriptCore -Wl,-no-whole-archive -L${PWD}/qtwebkit/Source/JavaScriptCore[^ ]* ||" \
    -e "s|-Wl,-whole-archive -lWTF -Wl,-no-whole-archive -L${PWD}/qtwebkit/Source/WTF[^ ]* ||" \
    -e "s|-Wl,-whole-archive -lleveldb -Wl,-no-whole-archive -L${PWD}/qtwebkit/Source/ThirdParty/leveldb[^ ]* ||" \
    "${PKG}/usr/lib${LIBDIRSUFFIX}/pkgconfig/Qt5WebKit.pc"

PKGLIB64="${PKG}/usr/lib${LIBDIRSUFFIX}"
# fix the path in prl files:
find "${PKGLIB64}" -type f -name '*.prl' -exec \
    sed -i -e '/^QMAKE_PRL_BUILD_DIR/d;s/\(QMAKE_PRL_LIBS =\).*/\1/' {} \;

# fix the qmake path in pri file:
PRI="${PKGLIB64}/qt5/mkspecs/modules/qt_lib_bootstrap_private.pri"
[ -f "${PRI}" ] && \
    sed -i "s,${QTDIR}/qtbase,/usr/lib${LIBDIRSUFFIX}/qt5," "${PRI}"

# restore QTDIR and LD_LIBRARY_PATH for further build packages
QTDIR="${QTD}"
export QTDIR
LD_LIBRARY_PATH=${LDLP}
export LD_LIBRARY_PATH

mkdir -p "${PKG}/install"
cat "${CWD}/slack-desc" > "${PKG}/install/slack-desc"
cat "${CWD}/doinst.sh" > "${PKG}/install/doinst.sh"

cd "${PKG}" || exit 1
mkdir -p "${OUTPUT}/deps"
BUILD=$(cat "${CWDD}/build/${PKGNAME}" 2>/dev/null || echo "1")
PKG="${OUTPUT}/deps/${PKGNAME}-${VERSION}-${ARCH}-${BUILD}_${TAG}.${EXT}"
rm -f "${PKG}"
makepkg -l y -c n "${PKG}"

if [[ "${INSTALL_AFTER_BUILD}" == "true" ]]; then
    upgradepkg --install-new --reinstall "${PKG}"
fi
