#!/bin/bash

export VERSION="${KDE4VERSION}"
echo "${VERSION}"
PKGVER="${PKGNAME}-${VERSION}"
export SOURCE="${PKGVER}.tar.xz"

if ! [ -r "${SRCDIR}/${MODULE}/${SOURCE}" ]; then
    SRCVER="$(echo "${PKGNAME}" | tr -d 4)-${VERSION}"
    SRCARCH="${SRCVER}.tar.xz"
    echo -e "${YELLOW}Downloading ${SRCARCH} source archive${CDEF}"
    (
        cd "${SRCDIR}/${MODULE}" || exit 1
        wget "${KDEDOWNLOAD}/${KDE4VERSION}/src/${SRCARCH}"
        echo -e "${YELLOW}Creating ${SOURCE} source archive${CDEF}"
        tar xf "${SRCARCH}" 1>/dev/null 2>&1
        rm -f "${SRCARCH}"
        mv "${SRCVER}" "${PKGVER}"
        tar -cJf "${PKGVER}.tar.xz" "${PKGVER}" 1>/dev/null
        rm -rf "${PKGVER}"
    )
fi
