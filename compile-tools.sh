#!/bin/bash
#
#  Get and compile taginfo tools
#

set -e
set -x

DIR=/srv/taginfo

cd $DIR

git clone https://github.com/osmcode/libosmium
git clone https://github.com/mapbox/protozero
git clone https://github.com/taginfo/taginfo-tools

mkdir build
cd build

git submodule update

cmake -DCMAKE_BUILD_TYPE=Release -DOSMIUM_INCLUDE_DIR=../libosmium/include -DPROTOZERO_INCLUDE_DIR=../protozero/include ../taginfo-tools

make -j2

