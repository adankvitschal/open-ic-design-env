#######################################################################
# Setup base image
#######################################################################
ARG BASE_IMAGE=rockylinux:8
FROM ${BASE_IMAGE} as base

USER root
ADD dependencies.sh dependencies.sh
RUN bash dependencies.sh

#######################################################################
# Set env options
#######################################################################
FROM base as env_options

ENV TOOLS_INSTALL_PATH=/usr/local/share
ENV SKY130_VERSION=B
ENV PDK_ROOT=$TOOLS_INSTALL_PATH/pdk
ENV PDK=sky130B

#######################################################################
# Compile magic
#######################################################################
FROM env_options as magic
ARG MAGIC_REPO_URL="https://github.com/rtimothyedwards/magic"
ARG MAGIC_VERSION=8.3.322

ADD magic/install.sh install.sh
RUN bash install.sh

#######################################################################
# Compile skywater-pdk
#######################################################################
FROM magic as skywater-pdk
ARG SKYWATER_PDK_REPO_URL="https://github.com/google/skywater-pdk"

#COPY skywater-pdk/corners/corners.yml $PDK_ROOT/corners.yml
#COPY skywater-pdk/corners/make_timing.py $PDK_ROOT/make_timing.py

ADD skywater-pdk/install.sh install.sh
RUN bash install.sh

#######################################################################
# Compile open_pdks
#######################################################################
FROM skywater-pdk as open_pdks
ARG OPEN_PDKS_REPO_URL="https://github.com/RTimothyEdwards/open_pdks"
ARG OPEN_PDKS_VERSION=1.0.329

ADD open_pdks/install.sh install.sh
RUN bash install.sh

#######################################################################
# Compile shared libngspice
#######################################################################
FROM env_options as libngspice
ARG NGSPICE_REPO_URL="https://git.code.sf.net/p/ngspice/ngspice"
ARG NGSPICE_VERSION=ngspice-37

ADD libngspice/install.sh install.sh
RUN bash install.sh

#######################################################################
# Compile ngspice
#######################################################################
FROM env_options as ngspice
ARG NGSPICE_REPO_URL="https://git.code.sf.net/p/ngspice/ngspice"
ARG NGSPICE_VERSION=ngspice-37

ADD ngspice/install.sh install.sh
RUN bash install.sh

#######################################################################
# Compile xschem
#######################################################################
FROM env_options as xschem
ARG XSCHEM_REPO_URL="https://github.com/StefanSchippers/xschem"
ARG XSCHEM_VERSION=3.1.0

ADD xschem/install.sh install.sh
RUN bash install.sh

#######################################################################
# Merge compiled software and config EDA env
#######################################################################
FROM env_options as merge-compiled

COPY --from=open_pdks         ${TOOLS_INSTALL_PATH}       ${TOOLS_INSTALL_PATH}
COPY --from=magic             ${TOOLS_INSTALL_PATH}       ${TOOLS_INSTALL_PATH}
COPY --from=ngspice           ${TOOLS_INSTALL_PATH}       ${TOOLS_INSTALL_PATH}
COPY --from=libngspice        ${TOOLS_INSTALL_PATH}       ${TOOLS_INSTALL_PATH}
COPY --from=xschem            ${TOOLS_INSTALL_PATH}       ${TOOLS_INSTALL_PATH}

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${TOOLS_INSTALL_PATH}/ngspice/lib"

ENV PATH="${PATH}:${TOOLS_INSTALL_PATH}/magic/bin"
ENV PATH="${PATH}:${TOOLS_INSTALL_PATH}/ngspice/bin"
ENV PATH="${PATH}:${TOOLS_INSTALL_PATH}/xschem/bin"

#######################################################################
# Install ngspyce to interface python with ngspice
#######################################################################
FROM merge-compiled as ngspyce 
ADD ngspyce/install.sh install.sh
RUN bash install.sh

#######################################################################
# Install X and VNC servers
#######################################################################
FROM ngspyce as install-graphic

ADD desktop/install.sh install.sh
RUN bash install.sh

#######################################################################
# Config vnc, env, user and GO!
#######################################################################
FROM install-graphic as sky130-analog-env

ENV VNC_PORT=5901
EXPOSE $VNC_PORT

ENV TERM=xterm \
    VNC_COL_DEPTH=32 \
    VNC_RESOLUTION=1600x900 \
    VNC_PW=moduhub

#Create user, add to wheel
RUN useradd -ms /bin/bash moduhub
RUN echo "moduhub" | passwd --stdin moduhub
RUN usermod -aG wheel moduhub

#Populate home and set ownership
ADD user_config/home $HOME
ADD desktop/start.sh start.sh
RUN chown -R moduhub /home/moduhub/*
RUN chgrp -R moduhub /home/moduhub/*

USER moduhub
WORKDIR /home/moduhub
RUN mkdir $HOME/work

ENTRYPOINT bash start.sh