#!/bin/bash

# use ck-launch-session in runlevel 3 to start and attach a ConsoleKit session
# to the X session
mkdir -p "${PKG}/etc/X11/xinit"
XINITRC="\
    xinitrc.plasma \
    xinitrc.kwayland \
"
for XINIT in ${XINITRC}; do
    zcat "${CWD}/post-install/${PKGNAME}/xinit/${XINIT}.gz" \
        | sed -e "s/@LIBDIRSUFFIX@/${LIBDIRSUFFIX}/g" > \
        "${PKG}/etc/X11/xinit/${XINIT}"
done
chmod 0755 "${PKG}/etc/X11/xinit/xinitrc.plasma"

# Add a "fail-safe" version of KDE Plasma desktop session. Prefix the name with
# "z_" because SDDM is braindead
mkdir -p "${PKG}/usr/share/xsessions"
zcat "${CWD}/post-install/${PKGNAME}/xsession/plasma-safe.desktop.gz" >  \
    "${PKG}/usr/share/xsessions/z_plasma-safe.desktop"

# what is "plugins/plugins"?
mv "${PKG}"/usr/lib64/qt5/plugins/{plugins,}/phonon_platform
rm -rf "${PKG}/usr/lib64/qt5/plugins/plugins"

# move the polkit dbus configuration files to the proper place
DBUS="${PKG}/etc/kde/dbus-1"
[ -d "${DBUS}" ] && mv "${DBUS}" "${PKG}/etc"

# for shadow, this file needs to be setuid root just like the KDE4 version
KCHECKPASS="${PKG}/usr/lib${LIBDIRSUFFIX}/kcheckpass"
if [ -f "${KCHECKPASS}"  ]; then
    chmod +s "${KCHECKPASS}"
fi
