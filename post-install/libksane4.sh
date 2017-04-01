#!/bin/bash

ICONS="${PKG}/usr/share/icons"
if [ -d "${ICONS}" ]; then
    rm -rf "${ICONS}"
fi
