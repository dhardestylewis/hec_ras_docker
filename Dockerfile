FROM centos:7

MAINTAINER Daniel Hardesty Lewis <dhl@tacc.utexas.edu>

## Set up HEC-RAS environment
ENV RAS_LIB_PATH /opt/HEC-RAS_610_Linux/RAS_Linux_test_setup/libs:/opt/HEC-RAS_610_Linux/RAS_Linux_test_setup/libs/mkl:/opt/HEC-RAS_610_Linux/RAS_Linux_test_setup/libs/centos_7
ENV LD_LIBRARY_PATH ${RAS_LIB_PATH}:${LD_LIBRARY_PATH}
ENV RAS_EXE_PATH /opt/HEC-RAS_610_Linux/RAS_Linux_test_setup/Ras_v61/Release
ENV PATH ${RAS_EXE_PATH}:${PATH}

RUN yum -y update && \
    yum -y install \
        wget \
        unzip && \
    yum -y clean all && \
    rm -rf /var/cache/yum
##
#### Retrieve HEC-RAS RHEL8 binaries
RUN wget -O /opt/HEC-RAS_610_Linux.zip https://www.hec.usace.army.mil/software/hec-ras/downloads/HEC-RAS_610_Linux.zip && \
    unzip /opt/HEC-RAS_610_Linux.zip -d /opt && \
    unzip /opt/HEC-RAS_610_Linux/RAS_Linux_test_setup.zip -d /opt/HEC-RAS_610_Linux && \
    chmod +x /opt/HEC-RAS_610_Linux/RAS_Linux_test_setup/Ras_v61/Release/*
####
###### Run HEC-RAS unit test
WORKDIR "/opt/HEC-RAS_610_Linux/RAS_Linux_test_setup/Muncie"
RUN rm Muncie.p04.hdf && \
    cp wrk_source/Muncie.p04.tmp.hdf . && \
    RasUnsteady Muncie.c04 b04
##
