#!/bin/bash

cd "${SRCDIR}/${MODULE}" || exit 1
rm -rf "${PKGNAME}"
git clone "git://anongit.kde.org/kwebkitpart.git"
cd "${PKGNAME}" || exit 1
VERSION=$(git tag | tr -d "v" | sort -V | tail -n 1)
export VERSION
cd .. || exit 1

echo "${VERSION}"
PKGVER="${PKGNAME}-${VERSION}"
export SOURCE="${PKGVER}.tar.xz"

if ! [ -r "${SOURCE}" ]; then
    cd "${PKGNAME}" || exit 1
    COMMIT=$(git show "v${VERSION}" | grep "commit " | cut -d " " -f 2)
    git reset --hard "${COMMIT}" 1>/dev/null 2>&1
    cd .. || exit 1
    rm -rf "${PKGNAME}/.git"
    mv "${PKGNAME}" "${PKGVER}"
    tar -cJf "${PKGVER}.tar.xz" "${PKGVER}" 1>/dev/null
    rm -rf "${PKGVER}"
else
    rm -rf "${PKGNAME}"
fi

cd "${CWD}" || exit 1
