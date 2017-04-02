#!/bin/bash

# create a symlink in /usr/bin to the kdesu binary
(
    KDESU="/usr/lib${LIBDIRSUFFIX}/kde4/libexec/kdesu"
    cd "${PKG}/usr/bin" || exit 1
    ln -s "${KDESU}" .
)

# remove the hicolor icon theme index.theme so it doesn't clobber the real one
HICOLOR="${PKG}/usr/share/icons/hicolor/index.theme"
[ -f "${HICOLOR}" ] && rm -f "${HICOLOR}"

# move the dbus configuration files to the proper place
DBUS="${PKG}/etc/kde/dbus-1"
[ -d "${DBUS}" ] && mv "${DBUS}" "${PKG}/etc"

# remove html docs
HTML="${PKG}/usr/doc/${PKGNAME}-${VERSION}/HTML"
[ -d "${HTML}" ] && rm -rf "${HTML}"
