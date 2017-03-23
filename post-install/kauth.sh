#!/bin/bash

# move the kauth dbus configuration files to the proper place
DBUS="${PKG}/etc/kde/dbus-1"
[ -d "${DBUS}" ] && mv "${DBUS}" "${PKG}/etc/"
