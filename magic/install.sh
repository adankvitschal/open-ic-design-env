#!/bin/bash

set -e
source scl_source enable gcc-toolset-9

git clone ${MAGIC_REPO_URL} magic
cd magic
git checkout ${MAGIC_VERSION}
./configure --prefix=${TOOLS_INSTALL_PATH}/magic
make -j$(nproc)
make install
