#!/bin/bash

zcat "${CWD}/patches/${PKGNAME}/pykde4-fix-build.diff.gz" | \
     patch -p1 --verbose || exit 1
