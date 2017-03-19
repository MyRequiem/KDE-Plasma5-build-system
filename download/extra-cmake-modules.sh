#!/bin/bash

export VERSION="${KF_VERSION}"
echo "${VERSION}"
export SOURCE="${PKGNAME}-${VERSION}.tar.xz"
MINVER="$(echo "${VERSION}" | rev | cut -d . -f 2- | rev)"

if ! [ -r "${SRCDIR}/${MODULE}/${SOURCE}" ]; then
    echo -e "${YELLOW}Downloading ${SOURCE} source archive${CDEF}"
    (
        cd "${SRCDIR}/${MODULE}" || exit 1
        wget "${KDEDOWNLOAD}/${MODULE}/${MINVER}/${SOURCE}"
    )
fi
