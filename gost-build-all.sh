#!/usr/bin/env bash

sudo date 

rm -rf build
rm -f bin/gost.1.1.dylib

git checkout master
if [ "$1" = "pull" ]; then
  git pull
fi

OPENSSL_DIR="" 
ENGINESDIR="" 
./gost-build-3.sh 2>&1 | tee ossl3-build.txt \
	&& cp build/bin/gost.dylib ~/openssl-3/lib/engines-3/gost.3.0.dylib \
	&& cp build/bin/gost*sum ~/openssl-3/bin/

rm -rf build

OPENSSL_DIR="/opt/local/libexec/openssl3" 
ENGINESDIR="/opt/local/libexec/openssl3/lib/engines-3" 
./gost-build-3.sh 2>&1 | tee ossl3-build.txt \
	&& sudo cp build/bin/gost.dylib ${ENGINESDIR}/gost.3.0.dylib \
	&& sudo cp build/bin/gost*sum /opt/local/bin/ \
	&& sudo ln -sf ${ENGINESDIR}/gist.3.0.dylib ${ENGINESDIR}/gist.dylib \
	&& sudo ln -sf ${ENGINESDIR}/gist.dylib /opt/local/lib/engines-3/

git checkout openssl_1_1_1
if [ "$1" = "pull" ]; then
  git pull
fi

rm -rf build

OPENSSL_DIR=/opt/local/libexec/openssl11
ENGINESDIR=/opt/local/libexec/openssl11/lib/engines-1.1
./gost-build-3.sh 2>&1 | tee ossl111-build.txt \
	&& sudo cp build/bin/gost.1.1.dylib ${ENGINESDIR}/ \
	&& sudo ln -sf ${ENGINESDIR}/gost.1.1.dylib ${ENGINESDIR}/gost.dylib \
	&& sudo ln -sf ${ENGINESDIR}/gost.dylib /opt/local/lib/engines-1.1/
	#&& sudo cp build/bin/gost*sum /opt/local/bin/ 

git checkout master
