#!/bin/bash

DDIRS=". doc docs"
DOCS="AUTHORS COPYING* INSTALL NEWS *README* TODO ChangeLog* CHANGELOG VERSION \
    ABOUT-NLS LICENSE* RELEASE_NOTES MANIFEST LGPL_EXCEPTION.txt"
DOCDIR="${PKG}/usr/doc/${PKGNAME}-${VERSION}${ADDITIONAL_DIR}"

# txt docs
for DIR in $DDIRS; do
    for DOC in ${DOCS}; do
        DOC="${DIR}/${DOC}"
        if [[ -r "${DOC}" && "$(stat -c%s "${DOC}")" != "0" ]]; then
            mkdir -p "${DOCDIR}"
            cp "${DOC}" "${DOCDIR}"
        fi
    done
done

# html docs
if [ -d "${DOCDIR}" ]; then
    HTML=$(find "${DOCDIR}" -maxdepth 1 -type f -a \
        \( -name "*.html" -o -name "*.htm" \))

    if [[ "x${HTML}" != "x" ]]; then
        mkdir -p "${DOCDIR}/html"
        mv "${DOCDIR}"/*.{html,htm,png,css,js} "${DOCDIR}/html" 2>/dev/null
    fi
fi

# compress info files, if any:
INFODIR="${PKG}/usr/info"
if [ -d "${INFODIR}" ]; then
    rm -rf "${INFODIR}/dir"
    gzip -9 "${INFODIR}"/*
    chmod -R 644 "${INFODIR}"/*
fi

# if there are docs, move them:
SHARE="${PKG}/usr/share"
if [ -d "${SHARE}/doc" ]; then
    mkdir -p "${DOCDIR}"
    mv "${SHARE}"/doc/* "${DOCDIR}"
    rm -rf "${SHARE}/doc"
    # if "${PKG}/usr/share" directory is empty, remove it
    if [[ "$(find "${SHARE}" | wc -l)" == "1" ]]; then
        rm -rf "${SHARE}"
    fi
fi

# chmod for all docs and info files
if [ -d "${DOCDIR}" ]; then
    find "${DOCDIR}" -type d -exec chmod 755 {} \;
    find "${DOCDIR}" -type f -exec chmod 644 {} \;
fi
