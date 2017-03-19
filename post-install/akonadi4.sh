#!/bin/bash

# remove files that clash with the Frameworks version of akonadi;
# we need only the barebones of the old akonadi 0.x for kdepimlibs4:
rm -rf "${PKG}/usr/bin"
