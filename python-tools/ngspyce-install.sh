#!/bin/bash
git clone https://github.com/ignamv/ngspyce ngspyce
cd ngspyce
python3 setup.py install

cd ..
rm -rf ngspyce