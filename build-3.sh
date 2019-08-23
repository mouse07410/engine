#!/bin/bash -x

if [ "z${OPENSSL_DIR}" == "z" ]; then
    OPENSSL_DIR = "${HOME}/openssl-3"
fi
if [ "z${OPENSSL_ENGINES_DIR}" == "z" ]; then
    OPENSSL_ENGINES_DIR = "${OPENSSL_DIR}/lib/engines-3"
fi

OPENSSL_LIBS="-L${OPENSSL_DIR}/lib -lssl -lcrypto"
OPENSSL_CFLAGS="-I${OPENSSL_DIR}/include -march=native -Os -Ofast -std=gnu17"
OPENSSL_CONF="${OPENSSL_DIR}/etc/openssl/openssl.cnf"
OPENSSL_INCLUDE_DIR=${OPENSSL_DIR}/include
OPENSSL_CRYPTO_LIBRARY=${OPENSSL_DIR}/lib/libcrypto.dylib
OPENSSL_SSL_LIBRARY=${OPENSSL_DIR}/lib/libssl.dylib
PKG_CONFIG_PATH="${OPENSSL_DIR}/lib/pkgconfig:${PKG_CONFIG_PATH}"

rm -rf build

mkdir -p build
cd build
cmake ..
make && make test
