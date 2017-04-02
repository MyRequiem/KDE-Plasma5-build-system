#!/bin/bash

# remove html docs
DOCS="${PKG}/usr/doc/${PKGNAME}-${VERSION}"
[ -d "${DOCS}/HTML" ] && rm -rf "${DOCS}/HTML"
rm -f "${DOCS}"/*.png
