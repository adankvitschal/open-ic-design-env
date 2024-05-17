#!/bin/bash

set -e
source scl_source enable gcc-toolset-9

git clone ${NETGEN_REPO_URL} netgen
cd netgen
git checkout ${NETGEN_VERSION}

./configure --prefix=${TOOLS_INSTALL_PATH}/netgen \
--with-tcl=/usr/local/opt/tcl-tk/lib \
--with-tk=/usr/local/opt/tcl-tk/lib \
--x-includes=/opt/X11/include \
--x-libraries=/opt/X11/lib \
CFLAGS=-Wno-error=implicit-function-declaration
make -j$(nproc)
make install