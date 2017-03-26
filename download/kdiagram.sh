#!/bin/bash

URL="https://github.com/KDE/${PKGNAME}"
VERSION="$(wget -q -O - "${URL}/releases" | grep "/releases/tag/v" | \
    head -n 1 | rev | cut -d \" -f 2 | cut -d "v" -f 1 | rev)"
export VERSION
echo "${VERSION}"
export SOURCE="${PKGNAME}-${VERSION}.tar.gz"

if ! [ -r "${SRCDIR}/${MODULE}/${SOURCE}" ]; then
    ARCHNAME="v${VERSION}.tar.gz"
    echo -e "${YELLOW}Downloading ${ARCHNAME} source archive${CDEF}"
    (
        cd "${SRCDIR}/${MODULE}" || exit 1
        wget "${URL}/archive/${ARCHNAME}"
        mv "${ARCHNAME}" "${SOURCE}"
    )
fi
