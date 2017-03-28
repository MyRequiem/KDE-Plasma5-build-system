#!/bin/bash

export VERSION="${PLASMA_VERSION}"
echo "${VERSION}"
export SOURCE="${PKGNAME}-${VERSION}.tar.xz"

if ! [ -r "${SRCDIR}/${MODULE}/${SOURCE}" ]; then
    echo -e "${YELLOW}Downloading ${SOURCE} source archive${CDEF}"
    (
        cd "${SRCDIR}/${MODULE}" || exit 1
        wget "${KDEDOWNLOAD}/${MODULE}/${VERSION}/${SOURCE}"
    )
fi
