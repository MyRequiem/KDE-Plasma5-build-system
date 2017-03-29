#!/bin/bash

export VERSION="${PLASMA_VERSION}"
echo "${VERSION}"
EXT=".tar.xz"
PKGVER="${PKGNAME}-${VERSION}"
export SOURCE="${PKGVER}${EXT}"

if ! [ -r "${SRCDIR}/${MODULE}/${SOURCE}" ]; then
    SRCNAME="polkit-kde-agent-1-${VERSION}"
    echo -e "${YELLOW}Downloading ${SRCNAME}${EXT} source archive${CDEF}"
    (
        cd "${SRCDIR}/${MODULE}" || exit 1
        wget "${KDEDOWNLOAD}/${MODULE}/${VERSION}/${SRCNAME}${EXT}"
        tar xf "${SRCNAME}${EXT}" 1>/dev/null 2>&1
        rm -f "${SRCNAME}${EXT}"
        mv "${SRCNAME}" "${PKGVER}"
        tar -cJf "${PKGVER}${EXT}" "${PKGVER}" 1>/dev/null
        rm -rf "${PKGVER}"
    )
fi
