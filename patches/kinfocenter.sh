#!/bin/bash

# fix linking error
zcat "${CWD}/patches/${PKGNAME}/kinfocenter_libpci.patch.gz" | \
    patch -p1 --verbose || exit 1
