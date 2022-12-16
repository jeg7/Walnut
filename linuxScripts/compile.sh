#!/bin/bash

set -e

cd ../

git submodule update --init --recursive

find . -name '*~' -delete
find . -name '.*~' -delete

mkdir -p bin-int/
cd bin-int/

cmake -DWL_BUILD_LINUX=ON -DCMAKE_BUILD_TYPE=Debug ..
#cmake -DWL_BUILD_LINUX=ON -DCMAKE_BUILD_TYPE=Release ..
make -j 32
#make -j 8
