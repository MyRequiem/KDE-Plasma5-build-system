#!/bin/bash

# we use the daemon from kactivities-framework because that one is compatible
# with the kactivities 4 libraries but not vice-versa
rm -f "${PKG}/usr/bin/kactivitymanagerd"
