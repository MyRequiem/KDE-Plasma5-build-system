#!/bin/bash

# allow cmake to find our doctools
zcat "${CWD}/patches/kdelibs4support/FindDocBookXML4.cmake.diff.gz" | \
    patch -p1 --verbose || exit 1
