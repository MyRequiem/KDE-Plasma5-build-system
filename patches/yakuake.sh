#!/bin/bash

zcat "${CWD}/patches/${PKGNAME}/yakuake-3.0.3-QPlatformSurfaceEvent.diff.gz" | \
    patch -p1 --verbose || exit 1
