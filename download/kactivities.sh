#!/bin/bash

DOMAIN="http://mirrors.slackware.com"
URL="${DOMAIN}/slackware/slackware-${SLACKWAREVER}/source/kde/src/"
VERSION="$(wget -q -O - "${URL}" | grep "${PKGNAME}-" | \
    cut -d \" -f 8 | rev | cut -d - -f 1 | cut -d . -f 3- | rev)"

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
