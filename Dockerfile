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
ENV SKY130_VERSION=A
ENV PDK_ROOT=$TOOLS_INSTALL_PATH/pdk
ENV PDK=sky130A

#######################################################################
# Compile magic
#######################################################################
FROM env_options as magic
ARG MAGIC_REPO_URL="https://github.com/rtimothyedwards/magic"
ARG MAGIC_VERSION=8.3.463

ADD magic/install.sh install.sh
RUN bash install.sh

#######################################################################
# Compile skywater-pdk
#######################################################################
FROM magic as skywater-pdk
ARG SKYWATER_PDK_REPO_URL_BASE="https://github.com/efabless/skywater-pdk-libs-"

ADD skywater-pdk/install.sh install.sh
RUN bash install.sh

#######################################################################
# Compile open_pdks
#######################################################################
FROM skywater-pdk as open_pdks
ARG OPEN_PDKS_REPO_URL="https://github.com/RTimothyEdwards/open_pdks"
ARG OPEN_PDKS_VERSION=1.0.470

ADD open_pdks/install.sh install.sh
RUN bash install.sh

#######################################################################
# Compile shared libngspice
#######################################################################
FROM env_options as libngspice
ARG NGSPICE_REPO_URL="https://github.com/danchitnis/ngspice-sf-mirror"
ARG NGSPICE_VERSION=ngspice-42

ADD libngspice/install.sh install.sh
RUN bash install.sh

#######################################################################
# Compile ngspice
#######################################################################
FROM env_options as ngspice
ARG NGSPICE_REPO_URL="https://github.com/danchitnis/ngspice-sf-mirror"
ARG NGSPICE_VERSION=ngspice-42

ADD ngspice/install.sh install.sh
RUN bash install.sh

#######################################################################
# Compile xschem
#######################################################################
FROM env_options as xschem
ARG XSCHEM_REPO_URL="https://github.com/StefanSchippers/xschem"
ARG XSCHEM_VERSION=3.4.4

ADD xschem/install.sh install.sh
RUN bash install.sh

#######################################################################
# Compile netgen
#######################################################################
FROM env_options as netgen
ARG NETGEN_REPO_URL="https://github.com/RTimothyEdwards/netgen"
ARG NETGEN_VERSION=1.5.276

ADD netgen/install.sh install.sh
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
COPY --from=netgen            ${TOOLS_INSTALL_PATH}       ${TOOLS_INSTALL_PATH}

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${TOOLS_INSTALL_PATH}/ngspice/lib"

ENV PATH="${PATH}:${TOOLS_INSTALL_PATH}/magic/bin"
ENV PATH="${PATH}:${TOOLS_INSTALL_PATH}/ngspice/bin"
ENV PATH="${PATH}:${TOOLS_INSTALL_PATH}/xschem/bin"
ENV PATH="${PATH}:${TOOLS_INSTALL_PATH}/netgen/bin"

#######################################################################
# Install python based tools
#######################################################################
FROM merge-compiled as python-tools
ARG CACE_REPO_URL="https://github.com/efabless/cace"
ARG CACE_VERSION=b6b0b4c

WORKDIR /tmp
ADD python-tools/python-requirements.sh python-requirements.sh
ADD python-tools/ngspyce-install.sh ngspyce-install.sh
ADD python-tools/cace-install.sh cace-install.sh

RUN bash python-requirements.sh
RUN bash ngspyce-install.sh
RUN bash cace-install.sh

#######################################################################
# Install X and VNC servers
#######################################################################
FROM python-tools as install-graphic

ADD desktop/install.sh install.sh
RUN bash install.sh

#######################################################################
# Config vnc, env, user and GO!
#######################################################################
FROM install-graphic as sky130-analog-env

ENV VNC_PORT=5901
EXPOSE $VNC_PORT

ENV TERM=xterm \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1600x900 \
    VNC_PW=moduhub

#Create user, add to wheel
RUN yum install -y passwd
RUN useradd -ms /bin/bash moduhub
RUN echo "moduhub" | passwd --stdin moduhub
RUN usermod -aG wheel moduhub

#Populate home and set ownership
ADD user_config/home /home/moduhub/
ADD desktop/start.sh /home/moduhub/
RUN chown -R moduhub /home/moduhub
RUN chgrp -R moduhub /home/moduhub

USER moduhub
WORKDIR /home/moduhub
RUN mkdir $HOME/work

ENTRYPOINT ["/home/moduhub/start.sh"]