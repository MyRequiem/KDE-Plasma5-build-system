#!/bin/bash

zcat "${CWD}/patches/pykde4/pykde4-fix-build.diff.gz" | \
     patch -p1 --verbose || exit 1
