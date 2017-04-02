#!/bin/bash

# add profile scripts:
mkdir -p "${PKG}/etc/profile.d"
zcat "${CWD}/post-install/${PKGNAME}/profile.d/kde.sh.gz" | \
    sed -e "s#/lib/#/lib${LIBDIRSUFFIX}/#g" \
    > "${PKG}/etc/profile.d/kde.sh"
zcat "${CWD}/post-install/${PKGNAME}/profile.d/kde.csh.gz" | \
    sed -e "s#/lib/#/lib${LIBDIRSUFFIX}/#g" \
    > "${PKG}/etc/profile.d/kde.csh"

chmod 0755 "${PKG}/etc/profile.d/kde.sh"

# remove html docs
HTML="${PKG}/usr/doc/${PKGNAME}-${VERSION}/HTML"
[ -d "${HTML}" ] && rm -rf "${HTML}"
