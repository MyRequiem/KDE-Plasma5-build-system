#!/bin/bash

export VERSION="${KDE_APP_VERSION}"
echo "${VERSION}"
export SOURCE="${PKGNAME}-${VERSION}.tar.xz"

if ! [ -r "${SRCDIR}/${MODULE}/${SOURCE}" ]; then
    echo -e "${YELLOW}Downloading ${SOURCE} source archive${CDEF}"
    (
        cd "${SRCDIR}/${MODULE}" || exit 1
        wget "${KDEDOWNLOAD}/applications/${VERSION}/src/${SOURCE}"
    )
fi
