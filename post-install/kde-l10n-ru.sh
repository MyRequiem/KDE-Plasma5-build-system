#!/bin/bash

# remove all docs
DOCS="${PKG}/usr/doc"
[ -d "${DOCS}" ] && rm -rf "${DOCS}"
