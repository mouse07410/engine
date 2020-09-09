#!/bin/bash -x

sudo date 

rm -rf build
rm -f bin/gost.1.1.dylib

git checkout master
if [ "$1" = "pull" ]; then
  git pull
fi

OPENSSL_DIR="" ./gost-build-3.sh 2>&1 | tee ossl3-build.txt && cp build/bin/gost.3.0.dylib ~/openssl-3/lib/engines-3/ && cp build/bin/gost*sum ~/openssl-3/bin/

git checkout openssl_1_1_1
if [ "$1" = "pull" ]; then
  git pull
fi

rm -rf build

OPENSSL_DIR=/opt/local ./gost-build-3.sh 2>&1 | tee ossl111-build.txt && sudo cp build/bin/gost.1.1.dylib /opt/local/lib/engines-1.1/ && sudo cp build/bin/gost*sum /opt/local/bin/ 

git checkout master
