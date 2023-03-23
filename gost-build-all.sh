#!/usr/bin/env bash

sudo date 

rm -rf build
rm -f bin/gost.1.1.dylib

git checkout master
if [ "$1" = "pull" ]; then
  git pull
fi

########## OpenSSL source tree (GitHub master)
O_DIR="" 
E_DIR=""
P_DIR=""
THRE="-3-"
if [ -d ${HOME}/openssl-3 ]; then
	THREE="${THRE}" USE_DEVEL="True" OPENSSL_DIR=${O_DIR} ENGINESDIR=${E_DIR} ./gost-build-3.sh 2>&1 | tee ossl3m-build.txt
	if [ -r build/bin/gost.dylib ]; then
		cp build/bin/gost.dylib ${HOME}/openssl-3/lib/engines-3/gost.3.0.dylib
	   	ln -sf ${HOME}/openssl-3/lib/engines-3/gost.3.0.dylib ${HOME}/openssl-3/lib/engines-3/gost.dylib
   		cp build/bin/gostprov.dylib ${HOME}/openssl-3/lib/ossl-modules/
		cp build/bin/gost*sum ${HOME}/openssl-3/bin/
	fi
else
	echo "OpenSSL master source not available, skipping..."
	echo ""
fi

rm -rf build

########## OpenSSL-3.x Macports-installed
# Install as Provider 
O_DIR="/opt/local/libexec/openssl3" 
E_DIR="/opt/local/libexec/openssl3/lib/engines-3"
P_DIR="/opt/local/libexec/openssl3/lib/ossl-modules" 
THRE="-3m-"
if [ -d ${O_DIR} ]; then
	THREE="${THRE}" OPENSSL_DIR=${O_DIR} PROVDIR=${P_DIR} ENGINESDIR=${E_DIR} ./gost-build-3.sh 2>&1 | tee ossl3-build.txt
	if [ -r build/bin/gost.dylib ]; then
		sudo cp build/bin/gost.dylib ${E_DIR}/gost.3.0.dylib
		sudo ln -sf ${E_DIR}/gost.3.0.dylib ${E_DIR}/gost.dylib
		sudo ln -sf ${E_DIR}/gost.dylib /opt/local/lib/engines-3/
		sudo cp build/bin/gostprov.dylib ${P_DIR}/
	   	sudo ln -sf ${P_DIR}/gostprov.dylib /opt/local/lib/ossl-modules/
		sudo cp build/bin/gost*sum /opt/local/bin/
	fi
else
	echo "Macports-installed OpenSSL-3.x not found, skipping..."
	echo ""
fi


########## OpenSSL-1.1.1x
O_DIR=/opt/local/libexec/openssl11
E_DIR=/opt/local/libexec/openssl11/lib/engines-1.1
THRE="-"

if [ -d ${O_DIR} ]; then 
	git checkout openssl_1_1_1
	if [ "$1" = "pull" ]; then
	  git pull
	fi

	rm -rf build

	THREE="${THRE}" OPENSSL_DIR=${O_DIR} ENGINESDIR=${E_DIR} ./gost-build-3.sh 2>&1 | tee ossl111-build.txt
	if [ -r build/bin/gost.dylib ]; then
	    sudo cp build/bin/gost.1.1.dylib ${E_DIR}/
	    sudo ln -sf ${E_DIR}/gost.1.1.dylib ${E_DIR}/gost.dylib
	    sudo ln -sf ${E_DIR}/gost.dylib /opt/local/lib/engines-1.1/
	fi
else
	echo "OpenSSL-1.1x is not installed on this system, skipping..."
	echo ""
fi

git checkout master
