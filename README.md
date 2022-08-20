##### Table of contents

-  [Dockerfile for HEC-RAS](#dockerfile)

-  [Singularity instructions](#singularity)

-  [Initiating scripts](#scripting)

-  [Using TACC's Azure image](#azure)


<a name="dockerfile"/>

## Dockerfile for HEC-RAS

This [Dockerfile](https://github.com/dhardestylewis/hec_ras_docker/blob/main/Dockerfile) can be used as line-by-line installation instructions for HEC-RAS's software dependencies.

This Docker image contains the binary executables for HEC-RAS.

The general installation steps to get HEC-RAS going:
0) pull the HEC-RAS Docker image, *which only needs to be done once*
1) initiate a HEC-RAS container, mounting the locations of the HEC-RAS input/output directories
2) run HEC-RAS from within the HEC-RAS container


## **The following instructions are for Docker. Instructions for Singularity are below**

*Note*: In these instructions, we assume the current working directory ($PWD) contains the cloned HEC-RAS repository and the parent HEC-RAS input/output directories.

HEC-RAS commands may be run as one-off commands using this Docker image using the following shell command as a template:

```
docker run --name hec_ras_bash --rm -i -t --mount type=bind,source="$(pwd)",target="/mnt/host" dhardestylewis/hec_ras_docker:latest RasUnsteady Muncie.c04 b04  ## replace "Muncie.c04 b04" with your specific HEC-RAS model
```

or HEC-RAS can be wrapped together in a script with other commands and executed as follows:

```
docker run --name hec_ras_bash --rm -i -t --mount type=bind,source="$(pwd)",target="/mnt/host" dhardestylewis/hec_ras_docker:latest bash hec_ras_commands.sh
```

where `hec_ras_commands.sh` is written according to this template:

```
#!/bin/bash
rm Muncie.p04.hdf
cp wrk_source/Muncie.p04.tmp.hdf .
RasGeomPreprocess Muncie.x04  ## replace "Muncie.x04" with your specific HEC-RAS model
RasUnsteady Muncie.c04 b04  ## replace "Muncie.c04 b04" with your specific HEC-RAS model
```


<a name="singularity"/>

## **Singularity instructions**

The Singularity pull command is similar to the Docker pull command:

```
singularity pull \
    --name hec_ras.sif \
    docker://dhardestylewis/hec_ras_docker:latest
```

Once pulled, a one-off HEC-RAS command using Singularity can be issued:

```
singularity exec \
    hec_ras.sif \
    RasUnsteady Muncie.c04 b04  ## replace "Muncie.c04 b04" with your specific HEC-RAS model
```

An interactive shell in the Singularity container may be used for troubleshooting or debugging:

```
singularity exec \
    hec_ras.sif \
    bash
```


<a name="scripting"/>

## **HEC-RAS combined with other commands in a shell script**


*Note*: In these instructions, we assume the current working directory ($PWD) contains the cloned HEC-RAS repository and the parent HEC-RAS input/output directories.

HEC-RAS may be wrapped in a shell script and run using Docker:

```
docker run \
    --name hec_ras_bash \
    --rm \
    -i \
    -t \
    dhardestylewis/hec_ras_docker:latest \
    --mount type=bind,source="$(pwd)",target="/mnt/host" \
    bash -c './hec_ras_commands.sh'
```

where the file `hec_ras_commands.sh` may be written as:

```
#!/bin/bash

## Execute HEC-RAS
RasGeomPreprocess Muncie.x04  ## replace "Muncie.x04" with your specific HEC-RAS model
RasUnsteady Muncie.c04 b04  ## replace "Muncie.c04 b04" with your specific Muncie model
```

To do the same using Singularity, execute:

```
singularity exec \
    hec_ras.sif \
    bash -c './hec_ras_commands.sh'
```    

where `hec_ras_commands.sh` is written as above.


<a name="dockerfile"/>

## **Using TACC's Azure image for HEC-RAS**

Log into Microsoft Azure from Microsoft's web portal:
https://portal.azure.com
