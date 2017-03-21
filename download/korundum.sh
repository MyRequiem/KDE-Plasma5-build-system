#!/bin/bash

export VERSION="${KDE4VERSION}"
echo "${VERSION}"
export SOURCE="${PKGNAME}-${VERSION}.tar.xz"

if ! [ -r "${SRCDIR}/${MODULE}/${SOURCE}" ]; then
    echo -e "${YELLOW}Downloading ${SOURCE} source archive${CDEF}"
    (
        cd "${SRCDIR}/${MODULE}" || exit 1
        wget "${KDEDOWNLOAD}/${KDE4VERSION}/src/${SOURCE}"
    )
fi
