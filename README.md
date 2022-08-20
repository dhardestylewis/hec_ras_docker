##### Table of contents

[Dockerfile for HEC-RAS](#dockerfile)

[Singularity instructions](#singularity)

[Initiating scripts](#scripting)


<a name="dockerfile"/>

## Dockerfile for HEC-RAS

This [Dockerfile](https://github.com/dhardestylewis/hec_ras_docker/blob/main/Dockerfile) can be used as line-by-line installation instructions for HEC-RAS's software dependencies.

This Docker image contains the binary executables for HEC-RAS.

The general installation steps to get HEC-RAS going:
1) pull the HEC-RAS Docker image
2) initiate a HEC-RAS container, mounting the locations of the HEC-RAS input/output directories
3) run HEC-RAS from within the HEC-RAS container


## **The following instructions are for Docker. Instructions for Singularity are below**

*Note*: In these instructions, we assume the current working directory ($PWD) contains the cloned HEC-RAS repository and the parent HEC-RAS input/output directories.

HEC-RAS commands may be run as one-off commands using this Docker image using the following shell command as a template:

```
docker run --name hec_ras_bash --rm -i -t --mount type=bind,source="$(pwd)",target="/mnt/host" dhardestylewis/hec_ras_docker:latest RasUnsteady Muncie.c04 b04
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
RasUnsteady Muncie.c04 b04
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
    RasUnsteady Muncie.c04 b04
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
RasUnsteady Muncie.c04 b04
```

To do the same using Singularity, execute:

```
singularity exec \
    hec_ras.sif \
    bash -c './hec_ras_commands.sh'
```    

where `hec_ras_commands.sh` is written as above.



