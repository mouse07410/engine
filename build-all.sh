#!/bin/bash -x

sudo date && OPENSSL_DIR=/opt/local ./build-3.sh && sudo cp build/bin/gost.1.1.dylib /opt/local/lib/engines-1.1/ && sudo cp build/bin/gost*sum /opt/local/bin/ 

OPENSSL_DIR=$HOME/openssl-3 ./build-3.sh && cp build/bin/gost.3.0.dylib ~/openssl-3/lib/engines-3/ && cp build/bin/gost*sum ~/openssl-3/bin/
