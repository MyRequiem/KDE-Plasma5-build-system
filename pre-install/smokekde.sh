#!/bin/bash

# add "cmake_minimum_required(VERSION 2.8.9)" at top in CMakeLists.txt
if ! grep -q "cmake_minimum_required" CMakeLists.txt; then
    sed -i -e '1icmake_minimum_required(VERSION 2.8.9)' CMakeLists.txt
fi
