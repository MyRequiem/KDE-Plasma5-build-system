#!/bin/bash

PATCHPATH="${CWD}/patches/akonadi4"
PATCH="akonadi_dont-leak-old-external-payload-files.patch.gz"

zcat "${PATCHPATH}/${PATCH}" | patch -p1 --verbose || exit 1
