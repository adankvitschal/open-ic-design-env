#!/bin/bash

set -e
source scl_source enable gcc-toolset-9

export PATH=$PATH:${TOOLS_INSTALL_PATH}/magic/bin

cd $PDK_ROOT
git clone ${OPEN_PDKS_REPO_URL} open_pdks
cd open_pdks
git checkout -qf ${OPEN_PDKS_VERSION}

./configure \
	--enable-sky130-pdk=$PDK_ROOT/skywater-pdk \
	--enable-xschem-sky130
#	--with-sky130-variants=$SKY130_VERSION

make -j$(nproc)
make install

cp $PDK_ROOT/open_pdks/sky130/sky130${SKY130_VERSION}_make.log $PDK_ROOT/sky130${SKY130_VERSION}

make veryclean

cd $PDK_ROOT 
rm -rf skywater-pdk open_pdks 
chmod -R 755 $PDK_ROOT
