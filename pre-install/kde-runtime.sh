#!/bin/bash

# for some reason, cmake stumbles over identical directory names in
# doc/kcontrol and doc/kioslave
sed -i \
  -e "s/add_subdirectory(bookmarks)/add_subdirectory(kiobookmarks)/" \
  -e "s/add_subdirectory(smb)/add_subdirectory(kiosmb)/" \
  doc/kioslave/CMakeLists.txt

mv -i doc/kioslave/{,kio}bookmarks
mv -i doc/kioslave/{,kio}smb
