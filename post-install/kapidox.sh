#!/bin/bash

SHAREMAN="${PKG}/usr/share/man"
[ -d "${SHAREMAN}" ] && mv "${SHAREMAN}" "${PKG}/usr/"
