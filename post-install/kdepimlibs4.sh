#!/bin/bash

# remove files that clash with the Frameworks version of kdepimlibs
rm -rf "${PKG}/usr/bin"
rm -rf "${PKG}/usr/share/config.kcfg"

# remove html docs
HTML="${PKG}/usr/doc/${PKGNAME}-${VERSION}/HTML"
[ -d "${HTML}" ] && rm -rf "${HTML}"
