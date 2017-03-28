#!/bin/bash

# fix linking error
zcat "${CWD}/patches/kinfocenter/kinfocenter_libpci.patch.gz" | \
    patch -p1 --verbose || exit 1
