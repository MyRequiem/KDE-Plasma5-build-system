#!/bin/bash

# allow cmake to find our doctools
zcat "${CWD}/patches/${PKGNAME}/FindDocBookXML4.cmake.diff.gz" | \
    patch -p1 --verbose || exit 1
