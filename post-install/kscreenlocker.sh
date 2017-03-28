#!/bin/bash

# for shadow, this file needs to be setuid root just like the KDE4 version
KCHECKPASS="${PKG}/usr/lib${LIBDIRSUFFIX}/kcheckpass"
[ -f "${KCHECKPASS}" ] && chmod +s "${KCHECKPASS}"
