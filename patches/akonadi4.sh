#!/bin/bash

PATCH="akonadi_dont-leak-old-external-payload-files.patch.gz"
zcat "${CWD}/patches/${PKGNAME}/${PATCH}" | patch -p1 --verbose || exit 1
