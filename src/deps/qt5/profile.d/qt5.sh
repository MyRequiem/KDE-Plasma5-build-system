#!/bin/sh

# Environment variables for the Qt package.
#
# it's best to use the generic directory to avoid
# compiling in a version-containing path:
if [ -d /usr/lib@LIBDIRSUFFIX@/qt5 ]; then
    QT5DIR=/usr/lib@LIBDIRSUFFIX@/qt5
else
    # find the newest Qt directory and set $QT5DIR to that:
    for QTD in /usr/lib@LIBDIRSUFFIX@/qt5-* ; do
        if [ -d "${QTD}" ]; then
            QT5DIR="${QTD}"
        fi
    done
fi

PATH="$PATH:$QT5DIR/bin"
export QT5DIR
