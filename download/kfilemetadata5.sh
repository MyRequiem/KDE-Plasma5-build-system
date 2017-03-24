#!/bin/bash

export VERSION="${KF_VERSION}"
echo "${VERSION}"
PKGVER="${PKGNAME}-${VERSION}"
export SOURCE="${PKGVER}.tar.xz"

if ! [ -r "${SRCDIR}/${MODULE}/${SOURCE}" ]; then
    SRCVER="$(echo "${PKGNAME}" | tr -d 5)-${VERSION}"
    SRCNAME="${SRCVER}.tar.xz"
    echo -e "${YELLOW}Downloading ${SRCNAME} source archive${CDEF}"
    (
        cd "${SRCDIR}/${MODULE}" || exit 1
        MINVER="$(echo "${VERSION}" | rev | cut -d . -f 2- | rev)"
        wget "${KDEDOWNLOAD}/${MODULE}/${MINVER}/${SRCNAME}"
        tar xf "${SRCNAME}" 1>/dev/null 2>&1
        rm -f "${SRCNAME}"
        mv "${SRCVER}" "${PKGVER}"
        tar -cJf "${PKGVER}.tar.xz" "${PKGVER}" 1>/dev/null
        rm -rf "${PKGVER}"
    )
fi
