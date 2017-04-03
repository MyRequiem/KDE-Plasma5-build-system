#!/bin/bash

# kftpgrabber-svn needs FindLibSSH2 cmake module
CMAKEVER=$(cmake --version | grep "cmake version" | cut -d " " -f 3 | \
    cut -d . -f 1,2)
CMAKEMODULES="/usr/share/cmake-${CMAKEVER}/Modules/"
FINDLIBSSH2="FindLibSSH2.cmake"
GZ="${CWD}/pre-install/${PKGNAME}/${FINDLIBSSH2}.gz"

mkdir -p "${PKG}${CMAKEMODULES}"
zcat "${GZ}" > "${PKG}${CMAKEMODULES}/${FINDLIBSSH2}"
zcat "${GZ}" > "${CMAKEMODULES}/${FINDLIBSSH2}"
