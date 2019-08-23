#!/bin/bash -x

# NOTE: You *must* set OPENSSL_DIR env var if you want to build the GOST engine
# for OpenSSL-1.1.1+.

if [ -z ${OPENSSL_DIR} ]; then
    # Assume we are building for OpenSSL-3 (current master)
    OPENSSL_DIR="$HOME/openssl-3"
    OPENSSL_ENGINES_DIR="${OPENSSL_DIR}/lib/engines-3"
else
    # Assume we're building for stable OpenSSL-1.1.1x
    OPENSSL_ENGINES_DIR="${OPENSSL_DIR}/lib/engines-1.1"
fi

OPENSSL_INCLUDE_DIR="${OPENSSL_DIR}/include"
OPENSSL_CRYPTO_LIBRARY="${OPENSSL_DIR}/lib/libcrypto.dylib"
OPENSSL_SSL_LIBRARY="${OPENSSL_DIR}/lib/libssl.dylib" 
PKG_CONFIG_PATH="${OPENSSL_DIR}/lib/pkgconfig:${PKG_CONFIG_PATH}" 
OPENSSL_CFLAGS="-Os -Ofast -march=native -std=gnu17" 
LDFLAGS="" 
OPENSSL_LIB_DIR="${OPENSSL_DIR}/lib"
OPENSSL_CONF="${OPENSSL_DIR}/etc/openssl.cnf"

rm -rf build
mkdir -p build

cd build

cmake .. -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DOPENSSL_ENGINES_DIR=${OPENSSL_ENGINES_DIR} 2>&1 | tee ../cmake-out.txt
make VERBOSE=1 2>&1 | tee ../make-out.txt

make test 2>&1 | tee ../test-out.txt

#