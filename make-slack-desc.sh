#!/bin/bash

PKGNAME="$1"

if [[ "x${PKGNAME}" == "x" ]]; then
    echo "Usage: ./$(basename "$0") PKGNAME"
    exit 1
fi

if [ -f "slack-desc/${PKGNAME}" ]; then
    echo "A slack-desc file with name '${PKGNAME}' already exists."
    exit 1
fi

cat <<EOT > "slack-desc/${PKGNAME}"
# HOW TO EDIT THIS FILE:
# The "handy ruler" below makes it easier to edit a package description.  Line
# up the first '|' above the ':' following the base package name, and the '|'
# on the right side marks the last column you can put a character in.  You must
# make exactly 11 lines for the formatting to be correct.  It's also
# customary to leave one space after the ':'.

        |-----handy-ruler------------------------------------------------------|
${PKGNAME}: ${PKGNAME} ()
${PKGNAME}:
${PKGNAME}:
${PKGNAME}:
${PKGNAME}:
${PKGNAME}:
${PKGNAME}:
${PKGNAME}:
${PKGNAME}: Homepage:
${PKGNAME}: Download:
${PKGNAME}:
EOT
