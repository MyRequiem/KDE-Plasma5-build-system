#!/bin/bash

URL="${KDEDOWNLOAD}/${PKGNAME}/"
VERSION=$(wget -q -O - "${URL}" | grep "<a href=" | \
    grep -E '>([0-9]|\.)+\/<' | cut -d \" -f 4 | tr -d / | sort -V | \
    tail -n 1)
export VERSION
echo "${VERSION}"
export SOURCE="${PKGNAME}-${VERSION}.tar.bz2"

if ! [ -r "${SRCDIR}/${MODULE}/${SOURCE}" ]; then
    echo -e "${YELLOW}Downloading ${SOURCE} source archive${CDEF}"
    (
        cd "${SRCDIR}/${MODULE}" || exit 1
        wget "${URL}${VERSION}/src/${SOURCE}"
    )
fi
