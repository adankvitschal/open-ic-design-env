#!/bin/bash

mkdir -p $PDK_ROOT
cd $PDK_ROOT
mkdir skywater-pdk
cd skywater-pdk

git clone ${SKYWATER_PDK_REPO_URL_BASE}sky130_fd_pr sky130_fd_pr
git clone ${SKYWATER_PDK_REPO_URL_BASE}sky130_fd_io sky130_fd_io
