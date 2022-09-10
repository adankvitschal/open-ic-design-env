#!/bin/bash

set -e
source scl_source enable gcc-toolset-9

git clone ${XSCHEM_REPO_URL} xschem
cd xschem
git checkout ${XSCHEM_VERSION}
./configure --prefix=${TOOLS_INSTALL_PATH}/xschem
make -j$(nproc)
make install
