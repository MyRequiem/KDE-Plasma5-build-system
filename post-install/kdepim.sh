#!/bin/bash

# move the dbus configuration files to the proper place
DBUS="${PKG}/etc/kde/dbus-1"
[ -d "${DBUS}" ] && mv "${DBUS}" "${PKG}/etc/"

# kalarm should not start in XFCE
KALARMDESKTOP="${PKG}/etc/kde/xdg/autostart/kalarm.autostart.desktop"
if ! grep -q "OnlyShowIn=KDE;" "${KALARMDESKTOP}" ; then
    echo "OnlyShowIn=KDE;" >> "${KALARMDESKTOP}"
fi
