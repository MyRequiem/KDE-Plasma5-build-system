#!/bin/bash

# move the polkit dbus configuration files to the proper place
DBUS="${PKG}/etc/kde/dbus-1"
if [ -d "${DBUS}" ]; then
    ETC="${PKG}/etc"
    mkdir -p "${ETC}"
    mv "${DBUS}" "${ETC}"
fi
