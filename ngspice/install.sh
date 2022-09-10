#!/bin/bash

source scl_source enable gcc-toolset-9

git clone ${NGSPICE_REPO_URL} ngspice
cd ngspice
git checkout ${NGSPICE_VERSION}
./autogen.sh
#FIXME 2nd run of autogen needed
set -e
./autogen.sh
./configure --disable-debug --enable-openmp --with-x --with-readline=no --enable-xspice --with-fftw3=yes --prefix=${TOOLS_INSTALL_PATH}/ngspice
make -j$(nproc)
make install