#!/bin/bash

URL="${KDEDOWNLOAD}/ktorrent/"
VERSION=$(wget -q -O - "${URL}" | grep "<a href=" | \
    grep -E '>([0-9]|\.)+\/<' | cut -d \" -f 4 | tr -d / | sort -V | \
    tail -n 1)
URL="${URL}${VERSION}/"
VERSION=$(wget -q -O - "${URL}" | grep "<a href=" | grep "${PKGNAME}-" | \
    cut -d \" -f 4 | rev | cut -d - -f 1 | cut -d . -f 3- | rev | sort -V | \
    tail -n 1)
export VERSION
echo "${VERSION}"
export SOURCE="${PKGNAME}-${VERSION}.tar.xz"

if ! [ -r "${SRCDIR}/${MODULE}/${SOURCE}" ]; then
    echo -e "${YELLOW}Downloading ${SOURCE} source archive${CDEF}"
    (
        cd "${SRCDIR}/${MODULE}" || exit 1
        wget "${URL}${SOURCE}"
    )
fi
