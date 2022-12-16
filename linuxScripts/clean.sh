#!/bin/bash

set -e

cd ../

find . -name '*~' -delete
find . -name '.*~' -delete

cd bin-int/
make clean
cd ../

rm -rf bin-int/ bin/
