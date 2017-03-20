#!/bin/bash

case "$(uname -m)" in
    i?86)   export ARCH="i586"   ;;
    x86_64) export ARCH="x86_64" ;;
    *)      echo "Supported architectures: i586 or x86_64"; exit 1 ;;
esac

if [[ "${ARCH}" == "x86_64" ]]; then
    export LIBDIRSUFFIX="64"
    export SLKLDFLAGS="-L/usr/lib64"
    export SLKCFLAGS="-O2 -fPIC"
else
    export LIBDIRSUFFIX=""
    export SLKLDFLAGS=""
    export SLKCFLAGS="-O2 -march=i586 -mtune=i686"
fi

CWDD=$(pwd)
export CWDD
QTDIR="/usr/lib${LIBDIRSUFFIX}/qt"
export QTDIR

# number of parallel make jobs
export NUMJOBS=" -j7 "
# additional cmake flags
export KDE_OPT_ARGS=" -Wno-dev -DBUILD_TESTING=OFF -DKDE4_BUILD_TESTS=OFF "
