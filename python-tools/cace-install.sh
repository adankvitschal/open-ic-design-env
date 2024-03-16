#!/bin/bash
git clone ${CACE_REPO_URL} cace
cd cace
git checkout ${CACE_VERSION}

pip3 install --no-cache-dir -r requirements.txt
pip3 install --no-cache-dir -r requirements_dev.txt
#pip3 install --no-cache-dir -r requirements_docs.txt

make build
make install
#make docs

#cd ..
#rm -rf cace