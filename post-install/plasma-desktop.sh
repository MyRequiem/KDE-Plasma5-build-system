#!/bin/bash

# move the polkit dbus configuration files to the proper place
DBUS="${PKG}/etc/kde/dbus-1"
[ -d "${DBUS}" ] && mv "${DBUS}" "${PKG}/etc"

# remove html docs
HTML="${PKG}/usr/doc/${PKGNAME}-${VERSION}/HTML"
[ -d "${HTML}" ] && rm -rf "${HTML}"
