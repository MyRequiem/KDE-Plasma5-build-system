#!/bin/sh

# From http://bear.alienbase.nl/mirrors/alien-kde/source/5/deps/qt5/
# The original script qt5.SlackBuild is located in this directory.

PKGNAME="qt5"
VERSION="5.7.1"
SOURCE="qt-everywhere-opensource-src-${VERSION}.tar.xz"

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

# fix dangling symlinks
THP="qtwebengine/src/3rdparty/chromium/third_party"
rm -f "${THP}/mesa/src/src/gallium/state_trackers/d3d1x/w32api"
rm -f "${THP}/webrtc/tools/e2e_quality/audio/perf"
ln -s "../../../../../tools/perf" "${THP}/webrtc/tools/e2e_quality/audio/"

# patches:
# fix path to mysql header
zcat "${CWD}/patches/qt5.mysql.h.diff.gz" | patch -p1 --verbose || exit 1
# don't unload plugins in QPluginLoader (segfault in LXQT)
cd qtbase || exit 1
zcat "${CWD}/patches/qt5.qtbug-49061.patch.gz" | patch -p1 --verbose || exit 1
cd - || exit 1
# fix file chooser segfault on Gnome/Wayland
cd qtbase || exit 1
zcat "${CWD}/patches/qt5.qtbug-55583.patch.gz" | patch -p1 --verbose || exit 1
cd - || exit 1

sed -i -e "s/-O2/${SLKCFLAGS}/" qtbase/mkspecs/common/g++-base.conf || exit 1
sed -i -e "s/-O2/${SLKCFLAGS}/" qtbase/mkspecs/common/gcc-base.conf || exit 1
sed -i -e "/^QMAKE_LFLAGS\s/s,+=,+= ${SLKLDFLAGS},g" \
    qtbase/mkspecs/common/gcc-base.conf || exit 1

# enable h.264 codec support:
echo "WEBENGINE_CONFIG += use_proprietary_codecs" >> qtwebengine/.qmake.conf

export CFLAGS="${SLKCFLAGS}"
export CXXFLAGS="${SLKCFLAGS}"
export OPENSOURCE_CXXFLAGS="${SLKCFLAGS}"
export QTDIR="${TMP}/${UNPACKSRCDIR}"
LDLP="${LD_LIBRARY_PATH}"
LD_LIBRARY_PATH="${QTDIR}/qtbase/lib:${QTDIR}/qttools/lib"
LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${LDLP}"
export LD_LIBRARY_PATH
export QT_PLUGIN_PATH="${QTDIR}/qtbase/plugins"

./configure \
    -confirm-license \
    -opensource \
    -prefix /usr \
    -libdir "/usr/lib${LIBDIRSUFFIX}" \
    -bindir "/usr/lib${LIBDIRSUFFIX}/${PKGNAME}/bin" \
    -sysconfdir /etc/xdg \
    -headerdir "/usr/include/${PKGNAME}" \
    -datadir "/usr/share/${PKGNAME}" \
    -archdatadir "/usr/lib${LIBDIRSUFFIX}/${PKGNAME}" \
    -docdir "/usr/doc/${PKGNAME}-${VERSION}" \
    -examplesdir "/usr/doc/${PKGNAME}-${VERSION}/examples" \
    -system-libpng \
    -system-libjpeg \
    -system-pcre \
    -system-sqlite \
    -system-zlib \
    -plugin-sql-mysql \
    -plugin-sql-sqlite \
    -accessibility \
    -alsa \
    -dbus \
    -glib \
    -icu \
    -opengl \
    -openssl \
    -optimized-qmake \
    -qpa xcb \
    -qt-harfbuzz \
    -verbose \
    -xcb \
    -nomake examples \
    -nomake tests \
    -no-separate-debug-info \
    -no-strip \
    -no-use-gold-linker \
    -reduce-relocations \
    -no-pch

make "${NUMJOBS}" || make || exit 1
make install INSTALL_ROOT="${PKG}" || exit 1

echo "Strip binaries..."
. "${CWDD}"/additional-scripts/strip-binaries.sh
. "${CWDD}"/additional-scripts/copydocs.sh

# remove directory "global" from documentation dir
GLOBAL="${PKG}/usr/doc/${PKGNAME}-${VERSION}/global"
[ -d "${GLOBAL}" ] && rm -rf "${GLOBAL}"

# fix the path in prl files
find "${PKG}/usr/lib${LIBDIRSUFFIX}" -type f -name '*.prl' \
    -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d;s/\(QMAKE_PRL_LIBS =\).*/\1/' {} \;

# fix the qmake path in pri file
QT5LIB="usr/lib${LIBDIRSUFFIX}/qt5"
sed -i "s,${QTDIR}/qtbase,/${QT5LIB}," \
    "${PKG}/${QT5LIB}/mkspecs/modules/qt_lib_bootstrap_private.pri"

# install symlinks to the Qt5 binaries in the $PATH:
mkdir -p "${PKG}/usr/bin"
LIBBIN="lib${LIBDIRSUFFIX}/${PKGNAME}/bin"
for FILE in "${PKG}/usr/${LIBBIN}"/*; do
    FILE=$(basename "${FILE}")
    ln -s "../${LIBBIN}/${FILE}" "${PKG}/usr/bin/${FILE}-${PKGNAME}"
done

# set the QT5DIR variable in the environment
PROFILED="${PKG}/etc/profile.d"
mkdir -p "${PROFILED}"
for PROFILEEXT in sh csh; do
    sed -e "s,@LIBDIRSUFFIX@,${LIBDIRSUFFIX},g" \
        "${CWD}/profile.d/${PKGNAME}.${PROFILEEXT}" > \
        "${PROFILED}/${PKGNAME}.${PROFILEEXT}"
done
chmod 0755 "${PKG}/etc/profile.d/${PKGNAME}.sh"

# Qt5 logo
HICOLOR="${PKG}/usr/share/icons/hicolor"
mkdir -p "${HICOLOR}/48x48/apps"
convert qtdoc/doc/src/images/qt-logo.png  -resize 48x48 \
    "${HICOLOR}/48x48/apps/${PKGNAME}-logo.png"
# Assistant icons
ASSISTANT="qttools/src/assistant/assistant/images"
install -p -m644 -D "${ASSISTANT}/assistant.png" \
    "${HICOLOR}/32x32/apps/${PKGNAME}-assistant.png"
install -p -m644 -D "${ASSISTANT}/assistant-128.png" \
    "${HICOLOR}/128x128/apps/${PKGNAME}-assistant.png"
# Designer icon
install -p -m644 -D qttools/src/designer/src/designer/images/designer.png \
    "${HICOLOR}/128x128/apps/${PKGNAME}-designer.png"
# QDbusViewer icons
QDBUSIMAGES="qttools/src/qdbus/qdbusviewer/images"
install -p -m644 "${QDBUSIMAGES}/qdbusviewer.png" \
    "${HICOLOR}/32x32/apps/${PKGNAME}-qdbusviewer.png"
install -p -m644 "${QDBUSIMAGES}/qdbusviewer-128.png" \
    "${HICOLOR}/128x128/apps/${PKGNAME}-qdbusviewer.png"
# Linguist icons
for ICON in qttools/src/linguist/linguist/images/icons/linguist-*-32.png; do
    size=$(basename "${ICON}" | cut -d - -f 2)
    install -p -m644 -D "${ICON}" \
        "${HICOLOR}/${size}x${size}/apps/${PKGNAME}-linguist.png"
done

# .desktop files
APPLICATIONS="${PKG}/usr/share/applications"
mkdir -p "${APPLICATIONS}"

cat <<EOF > "${APPLICATIONS}/${PKGNAME}-designer.desktop"
[Desktop Entry]
Name=Qt5 Designer
GenericName=Interface Designer
Comment=Design GUIs for Qt5 applications
Exec=designer-qt5 -qt=5
Icon=qt5-designer
MimeType=application/x-designer;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF

cat <<EOF > "${APPLICATIONS}/${PKGNAME}-assistant.desktop"
[Desktop Entry]
Name=Qt5 Assistant
Comment=Shows Qt5 documentation and examples
Exec=assistant-qt5 -qt=5
Icon=qt5-assistant
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Documentation;
EOF

cat <<EOF > "${APPLICATIONS}/${PKGNAME}-linguist.desktop"
[Desktop Entry]
Name=Qt5 Linguist
Comment=Add translations to Qt5 applications
Exec=linguist-qt5 -qt=5
Icon=qt5-linguist
MimeType=text/vnd.trolltech.linguist;application/x-linguist;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF

cat <<EOF > "${APPLICATIONS}/${PKGNAME}-qdbusviewer.desktop"
[Desktop Entry]
Name=Qt5 QDbusViewer
GenericName=Qt5 D-Bus Debugger
Comment=Debug D-Bus applications
Exec=qdbusviewer-qt5
Icon=qt5-qdbusviewer
Terminal=false
Type=Application
Categories=Qt;Development;Debugger;
EOF

# restore QTDIR for further build packages
QTDIR="/usr/lib${LIBDIRSUFFIX}/qt"
export QTDIR

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
