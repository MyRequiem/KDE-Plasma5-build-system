#!/bin/bash

# move the polkit dbus configuration files to the proper place:
DBUS="${PKG}/etc/kde/dbus-1"
[ -d "${DBUS}" ] && mv "${DBUS}" "${PKG}/etc/"

# all these files conflict with the baloo5 package which also contains them
rm -rf "${PKG}/usr/bin"/*
rm -rf "${PKG}/usr/share/icons"
rm -f "${PKG}/usr/share/dbus-1/interfaces/org.kde.baloo.file.indexer.xml"

# do not autostart the baloo 4 service
rm -rf "${PKG}/usr/share/autostart"
