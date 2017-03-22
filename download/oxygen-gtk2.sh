#!/bin/bash

cd "${SRCDIR}/${MODULE}" || exit 1
SRCDIRNAME=$(echo "${PKGNAME}" | tr -d 2)
rm -rf "${SRCDIRNAME}"
git clone "git://anongit.kde.org/oxygen-gtk.git" 1>/dev/null 2>&1
cd "${SRCDIRNAME}" || exit 1
VERSION=$(git tag | grep -v gtk3 | tr -d "v" | sort -V | tail -n 1)
cd .. || exit 1

export VERSION
echo "${VERSION}"
PKGVER="${PKGNAME}-${VERSION}"
export SOURCE="${PKGVER}.tar.xz"

if ! [ -r "${SOURCE}" ]; then
    mv "${SRCDIRNAME}" "${PKGVER}"
    cd "${PKGVER}" || exit 1
    COMMIT=$(git show "v${VERSION}" | grep "commit " | cut -d " " -f 2)
    git reset --hard "${COMMIT}" 1>/dev/null 2>&1
    cd .. || exit 1
    rm -rf "${PKGVER}/.git"
    tar -cJf "${PKGVER}.tar.xz" "${PKGVER}" 1>/dev/null
    rm -rf "${PKGVER}"
else
    rm -rf "${SRCDIRNAME}"
fi

cd "${CWD}" || exit 1
