#!/bin/bash -x

#
# Input taken via environment variables:
#
#    OPENSSL_DIR: where binary OpenSSL installation is
#       if empty, assume $HOME/openssl-3
#
#    ENGINESDIR: where this OpenSSL version places engines
#       if empty, assume ${OPENSSL_DIR}/lib/engines-3
#
#    THREE: sub-suffix for the output log files (default - empty/none)
#
# NOTE: You *must* set OPENSSL_DIR env var if you want to build the GOST engine
# for OpenSSL-1.1.1+ or Macports-installed OpenSSL (3.x or 1.1.1x).
# 

if [ -z ${OPENSSL_DIR} ]; then
    # Assume we are building for OpenSSL-3 (current master)
    LDFLAGS="" 
    OPENSSL_DIR="$HOME/openssl-3"
    THREE="-3-"
fi

if [ -z ${ENGINESDIR} ]; then
    ENGINESDIR="${OPENSSL_DIR}/lib/engines-3"
fi

OPENSSL_ENGINES_DIR=${ENGINESDIR}

if [ -z ${CC} ]; then
    CC="clang"
fi

#if [ -z "${OPENSSL_ROOT_DIR}" ]; then
    export OPENSSL_ROOT_DIR=${OPENSSL_DIR}
#fi

if [ -z ${DEBUG} ]; then
    # DEBUG not set, building Release
    CMAKE_BUILD_TYPE=Release
else
    # Since env var DEBUG was set, build type is Debug
    CMAKE_BUILD_TYPE=Debug
fi

OPENSSL_INCLUDE_DIR="${OPENSSL_DIR}/include"
OPENSSL_CRYPTO_LIBRARY="${OPENSSL_DIR}/lib/libcrypto.dylib"
OPENSSL_SSL_LIBRARY="${OPENSSL_DIR}/lib/libssl.dylib" 
PKG_CONFIG_PATH="${OPENSSL_DIR}/lib/pkgconfig:${PKG_CONFIG_PATH}" 
OPENSSL_CFLAGS="-march=native -std=gnu17" 
OPENSSL_LIB_DIR="${OPENSSL_DIR}/lib"
OPENSSL_CONF="${OPENSSL_DIR}/etc/openssl/openssl.cnf"

echo ""
echo "OPENSSL_DIR=\"${OPENSSL_DIR}\""
echo "ENGINESDIR=\"${ENGINESDIR}\""
echo "OPENSSL_ROOT_DIR=\"${OPENSSL_ROOT_DIR}\""
echo ""

rm -rf build
mkdir -p build

cd build

cmake .. -DCMAKE_C_COMPILER=${CC} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DOPENSSL_ROOT_DIR=${OPENSSL_ROOT_DIR} -DOPENSSL_ENGINES_DIR=${OPENSSL_ENGINES_DIR} 2>&1 | tee ../cmake${THREE}out.txt
make VERBOSE=1 2>&1 | tee ../make${THREE}out.txt

make test 2>&1 | tee ../test${THREE}out.txt
make test ARGS='-V' 2>&1 | tee ../test${THREE}long-out.txt

#
