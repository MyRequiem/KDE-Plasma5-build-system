#!/bin/bash

RET=$(pwd)
cd "${SRCDIR}/${MODULE}" || exit 1
svn co "svn://anonsvn.kde.org/home/kde/trunk/extragear/network/${PKGNAME}/" \
    1>/dev/null
VERSION="$(grep VERSION "${PKGNAME}/ChangeLog" | head -n 1 | cut -d " " -f 2)"
export VERSION
echo "${VERSION}"
PKGVER="${PKGNAME}-${VERSION}"
export SOURCE="${PKGVER}.tar.xz"

if ! [ -r "${SOURCE}" ]; then
    mv "${PKGNAME}" "${PKGVER}"
    rm -rf "${PKGVER}/.svn"
    tar -cJf "${SOURCE}" "${PKGVER}" 1>/dev/null
    rm -rf "${PKGVER}"
else
    rm -rf "${PKGNAME}"
fi

cd "${RET}" || exit 1
