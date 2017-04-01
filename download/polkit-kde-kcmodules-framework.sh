#!/bin/bash

RET=$(pwd)
cd "${SRCDIR}/${MODULE}" || exit 1
SRCDIR="polkit-kde-kcmodules-1"
git clone "git://anongit.kde.org/${SRCDIR}.git" 1>/dev/null 2>&1
DATE=$(cd ${SRCDIR} && git log -1 --format=%ad --date=format:%d%m%Y)
COMMIT=$(cd ${SRCDIR} && git log -1 --format=%h)

export VERSION="${DATE}_${COMMIT}"
echo "${VERSION}"
EXT=".tar.xz"
PKGVER="${PKGNAME}-${VERSION}"
export SOURCE="${PKGVER}${EXT}"

if ! [ -r "${SOURCE}" ]; then
    rm -rf "${SRCDIR}"/.git*
    mv "${SRCDIR}" "${PKGVER}"
    tar -cJf "${SOURCE}" "${PKGVER}" 1>/dev/null
    rm -rf "${PKGVER}"
else
    rm -rf "${SRCDIR}"
fi

cd "${RET}" || exit 1
