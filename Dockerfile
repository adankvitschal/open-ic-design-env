#######################################################################
# Start from JKU IIC env
#######################################################################
FROM hpretl/iic-osic-tools:latest as base
USER root
ADD dependencies.sh dependencies.sh
RUN bash dependencies.sh

#######################################################################
# reinstall ngspice with shared libs
#######################################################################
FROM base as libngspice
ARG NGSPICE_REPO_URL="https://git.code.sf.net/p/ngspice/ngspice"
ARG NGSPICE_REPO_COMMIT="1a6a9e6bb60ad8d07ecbfb3f35dea22379fb73e9"
ARG NGSPICE_NAME="ngspice"

ADD libngspice/install.sh install.sh
RUN bash install.sh

#######################################################################
# Install ngspyce to interface python with ngspice
#######################################################################
FROM libngspice as ngspyce 
ADD ngspyce/install.sh install.sh
RUN bash install.sh

#######################################################################
# Give up root user at end
#######################################################################
FROM ngspyce as sky130-env-final
USER root