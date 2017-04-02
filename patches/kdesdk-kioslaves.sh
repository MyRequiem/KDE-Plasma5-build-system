#!/bin/bash

# fix compilation against svn > 1.8
zcat "${CWD}/patches/${PKGNAME}/svn19.patch.gz" | \
    patch -p1 --verbose || exit 1
