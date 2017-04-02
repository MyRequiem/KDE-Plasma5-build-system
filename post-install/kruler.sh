#!/bin/bash

# remove html docs
HTML="${PKG}/usr/doc/${PKGNAME}-${VERSION}/HTML"
[ -d "${HTML}" ] && rm -rf "${HTML}"
