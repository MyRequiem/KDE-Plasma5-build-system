#!/bin/bash

# configure about-distro
XDG="${PKG}/etc/kde/xdg"
mkdir -p "${XDG}"
install -m0644 -o root "${CWD}/post-install/kinfocenter/blueSW-128px.png" \
    "${XDG}/slackware_logo.png"
install -m0644 -o root "${CWD}/post-install/kinfocenter/kcm-about-distrorc.ex" \
    "${XDG}/kcm-about-distrorc"

# remove HTML doc directory
HTML="${PKG}/usr/doc/${PKGNAME}-${VERSION}/HTML"
[ -d "${HTML}" ] && rm -rf "${HTML}"
