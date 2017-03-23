#!/bin/bash

export VERSION="${KF_VERSION}"
echo "${VERSION}"
PKGVER="${PKGNAME}-${VERSION}"
export SOURCE="${PKGVER}.tar.xz"

if ! [ -r "${SRCDIR}/${MODULE}/${SOURCE}" ]; then
    cd "${SRCDIR}/${MODULE}" || exit 1
    git clone "git://anongit.kde.org/${PKGNAME}.git"
    cd "${PKGNAME}" || exit 1
    COMMIT=$(git show "v${VERSION}" | grep "commit " | cut -d " " -f 2)
    git reset --hard "${COMMIT}" 1>/dev/null 2>&1
    cd .. || exit 1
    rm -rf "${PKGNAME}/.git"
    mv "${PKGNAME}" "${PKGVER}"
    tar -cJf "${SOURCE}" "${PKGVER}" 1>/dev/null
    rm -rf "${PKGVER}"
    cd "${CWD}" || exit 1
fi
