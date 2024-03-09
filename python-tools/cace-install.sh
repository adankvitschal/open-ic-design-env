#!/bin/bash
git clone https://github.com/efabless/cace cace
cd cace

pip3 install --no-cache-dir -r requirements.txt
pip3 install --no-cache-dir -r requirements_dev.txt

make build
make install

cd ..
rm -rf cace