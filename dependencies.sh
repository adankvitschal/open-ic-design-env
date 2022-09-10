#!/bin/bash

yum update -y

#yum upgrade -y
#yum install -y https://repo.ius.io/ius-release-el7.rpm 

yum install yum-utils -y
dnf config-manager --set-enabled powertools
yum install epel-release -y

yum group install "Development Tools" -y

#yum install centos-release-scl -y
yum install -y \
	alsa-lib \
	alsa-lib-devel \
	autoconf \
	automake \
	bison \
	blas \
	blas-devel \
	bzip2 \
	bzip2-devel \
	ca-certificates \
	cairo \
	cairo-devel \
	clang \
	cmake \
	csh \
	curl \
	fftw \
	fftw-devel \
	flex \
	flex-devel \
	gawk \
	gcc \
	gcc-c++ \
	gcc-gnat \
	gcc-toolset-9 \
	gcc-toolset-9-gcc-gfortran \
	gcc-toolset-9-libatomic-devel \
	gdb \
	gettext \
	gettext-devel \
	git \
	glibc-static \
	gperf \
	graphviz \
	gtk3 \
	gtk3-devel \
	help2man \
	langpacks-en \
	lapack \
	lapack-devel \
	libffi \
	libffi-devel \
	libgomp \
	libjpeg \
	libmng \
	libSM \
	libstdc++ \
	libstdc++-static \
	libtool \
	libX11 \
	libX11-devel \
	libXaw \
	libXaw-devel \
	libxcb \
	libxcb-devel \
	libXext \
	libXft \
	libxml2-devel \
	libXpm \
	libXpm-devel \
	libXrender \
	libXrender-devel \
	libxslt-devel \
	libyaml \
	llvm \
	llvm-devel \
	make \
	mesa-libGLU-devel \
	ncurses-devel \
	ninja-build \
	openmpi \
	openmpi-devel \
	patch \
	pciutils \
	pciutils-libs \
	pcre-devel \
	python3 \
	python3-Cython \
	python3-devel \
	python3-jinja2 \
	python3-matplotlib \
	python3-numpy \
	python3-pandas \
	python3-pip \
	python3-tkinter \
	python3-xlsxwriter \
	readline-devel \
	spdlog \
	spdlog-devel \
	strace \
	suitesparse \
	suitesparse-devel \
	swig \
	tcl \
	tcl-devel \
	texinfo \
	tk \
	tk-devel \
	unzip \
	vim-common \
	wget \
	which \
	wxGTK3 \
	wxGTK3-devel \
	Xvfb \
	xz-devel \
	zip \
	zlib-devel \
	zlib-static

#alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 60

#pip3.6 install --no-cache-dir --upgrade pip
#pip install --no-cache-dir \
#	matplotlib \
#	"jinja2<3.0.0" \
#	pandas \
#	install \
#	XlsxWriter

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

#These lines were needed to upgrade iic-osic-toosl machine, if starting from scratch maybe not
#pip3 install --upgrade scipy
#pip3 install --upgrade pip
#pip install --upgrade matplotlib	#this is a workaround to a bug with the Pìllow lib
