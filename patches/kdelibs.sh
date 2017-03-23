#!/bin/bash

PATCHPATH="${CWD}/patches/kdelibs"

# Slackware ships a different version of XML DTDs
zcat "${PATCHPATH}/kdelibs.docbook.patch.gz" | \
    patch -p1 --verbose || exit 1

# make uPnP support depend on the environment variable SOLID_UPNP,
# e.g. by creating an /etc/profile.d/upnp.sh file with the following contents
zcat "${PATCHPATH}/kdelibs.upnp_conditional.patch.gz" | \
    patch -p1 --verbose || exit 1

# revert 3 patches which (although they probably follow the FDo spec better),
# cause incorrect icon overrides
zcat "${PATCHPATH}/return-not-break.-copy-paste-error.patch.gz" | \
    patch -R -p1 --verbose || exit 1
zcat "${PATCHPATH}/coding-style-fixes.patch.gz" | \
    patch -R -p1 --verbose || exit 1
zcat "${PATCHPATH}/return-application-icons-properly.patch.gz" | \
    patch -R -p1 --verbose || exit 1
