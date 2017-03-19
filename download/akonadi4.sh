#!/bin/bash

URL="https://download.kde.org/stable/akonadi/src/"
VERSION=$(wget -q -O - "${URL}" | grep "<a href=\"akonadi-" | cut -d \" -f 4 | \
    rev | cut -d - -f 1 | cut -d . -f 3- | rev | sort -V | tail -n 1)
export VERSION
echo "${VERSION}"

PKGVER="${PKGNAME}-${VERSION}"
export SOURCE="${PKGVER}.tar.xz"

if ! [ -r "${SRCDIR}/${MODULE}/${SOURCE}" ]; then
    SRCVER="$(echo "${PKGNAME}" | tr -d 4)-${VERSION}"
    SRCARCH="${SRCVER}.tar.bz2"
    echo -e "${YELLOW}Downloading ${SRCARCH} source archive${CDEF}"
    (
        cd "${SRCDIR}/${MODULE}" || exit 1
        wget "${URL}${SRCARCH}"
        echo -e "${YELLOW}Creating ${SOURCE} source archive${CDEF}"
        tar xf "${SRCARCH}" 1>/dev/null 2>&1
        rm -f "${SRCARCH}"
        mv "${SRCVER}" "${PKGVER}"
        tar -cJf "${PKGVER}.tar.xz" "${PKGVER}" 1>/dev/null
        rm -rf "${PKGVER}"
    )
fi
