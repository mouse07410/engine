#!/bin/bash -x

# This script assumes your standard system installation is OpenSSL-1.1.1+,
# and a separate (not on the PATH) installation - OpenSSL-3.0 (GitHub master).
#
# NOTE: You *must* set OPENSSL_DIR env var if you want to build the GOST engine
# for OpenSSL-1.1.1+.
# 
# You may set OPENSSL_ROOT_DIR for OpenSSL-1.1.1+. It will be reset automatically
# if the script determines that the build is for OpenSSL-3.0 by finding that
# OPENSSL_DIR is *not* set.

if [ -z ${OPENSSL_DIR} ]; then
    # Assume we are building for OpenSSL-3 (current master)
    LDFLAGS="" 
    OPENSSL_DIR="$HOME/openssl-3"
    OPENSSL_ENGINES_DIR="${OPENSSL_DIR}/lib/engines-3"
    THREE="-3-"
    CMAKE_BUILD_TYPE=Debug
else
    # Assume we're building for stable OpenSSL-1.1.1x
    OPENSSL_ENGINES_DIR="${OPENSSL_DIR}/lib/engines-1.1"
    THREE="-"
    CMAKE_BUILD_TYPE=Release
fi
if [ -z ${OPENSSL_ROOT_DIR} ]; then
    OPENSSL_ROOT_DIR=${OPENSSL_DIR}
fi

OPENSSL_INCLUDE_DIR="${OPENSSL_DIR}/include"
OPENSSL_CRYPTO_LIBRARY="${OPENSSL_DIR}/lib/libcrypto.dylib"
OPENSSL_SSL_LIBRARY="${OPENSSL_DIR}/lib/libssl.dylib" 
PKG_CONFIG_PATH="${OPENSSL_DIR}/lib/pkgconfig:${PKG_CONFIG_PATH}" 
OPENSSL_CFLAGS="-march=native -std=gnu17" 
OPENSSL_LIB_DIR="${OPENSSL_DIR}/lib"
OPENSSL_CONF="${OPENSSL_DIR}/etc/openssl.cnf"

rm -rf build
mkdir -p build

cd build

cmake .. -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DOPENSSL_ROOT_DIR=${OPENSSL_ROOT_DIR} -DOPENSSL_ENGINES_DIR=${OPENSSL_ENGINES_DIR} 2>&1 | tee ../cmake${THREE}out.txt
make VERBOSE=1 2>&1 | tee ../make${THREE}out.txt

make test 2>&1 | tee ../test${THREE}out.txt
make test ARGS='-V' 2>&1 | tee ../test${THREE}long-out.txt

#
