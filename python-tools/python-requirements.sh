#!/bin/bash

yum install -y \
	python3.11 \
	python3.11-devel \
	python3.11-pip \
	python3.11-tkinter

alternatives --set python3 /usr/bin/python3.11
python3 --version

pip3 install --no-cache-dir install
pip3 install --no-cache-dir wheel
pip3 install --no-cache-dir \
	pyinstaller \
	pyverilog \
	pyyaml \
	spyci \
	tk \
	scipy \
	pandas \
	plotly \
	matplotlib