#!/bin/bash

set -e
source scl_source enable gcc-toolset-9

export PATH=$PATH:${TOOLS_INSTALL_PATH}/magic/bin

cd $PDK_ROOT
git clone ${OPEN_PDKS_REPO_URL} open_pdks
cd open_pdks
git checkout -qf ${OPEN_PDKS_VERSION}

./configure \
	--enable-sky130-pdk \
	--with-sky130-variants=$SKY130_VERSION \
	--enable-xschem-sky130 \
	--enable-primitive-sky130=$PDK_ROOT/skywater-pdk/sky130_fd_pr \
	--enable-io-sky130=$PDK_ROOT/skywater-pdk/sky130_fd_io \
	--disable-sc-hs-sky130 \
	--disable-sc-ms-sky130 \
	--disable-sc-ls-sky130 \
	--disable-sc-lp-sky130 \
	--disable-sc-hd-sky130 \
	--disable-sc-hdll-sky130 \
	--disable-sc-hvl-sky130 \
	--disable-alpha-sky130 \
	--disable-sram-sky130 \
	--disable-osu-t12-sky130 \
	--disable-osu-t15-sky130 \
	--disable-osu-t18-sky130

make -j$(nproc)
make install

cp $PDK_ROOT/open_pdks/sky130/sky130${SKY130_VERSION}_make.log $PDK_ROOT/sky130${SKY130_VERSION}

make veryclean

cd $PDK_ROOT 
rm -rf skywater-pdk open_pdks 
chmod -R 755 $PDK_ROOT
