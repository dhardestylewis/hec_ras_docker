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
1) pull the HEC-RAS Docker image, *which only needs to be done once*
2) initiate a HEC-RAS container, mounting the locations of the HEC-RAS input/output directories
3) run HEC-RAS from within the HEC-RAS container


## **Docker instructions**

**Instructions for Singularity are [below](#singularity). [@TACC](https://github.com/TACC) uses Singularity instead of Docker.**

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

*If you are using an [@TACC] machine, you will need to first need to:*

- login to [@TACC] from the command line
*for example, if you use ssh to login to @TACC:*
```bash
ssh username@ls6.tacc.utexas.edu
## substitute in the TACC supercomputer you are using above if not Lonestar6, for example stampede2.tacc.utexas.edu
```
*Please refer your supercomputer's user guide if you need help logging in, or reach out to us.* Here is [Lonestar6's user guide](https://portal.tacc.utexas.edu/user-guides/lonestar6#secure-shell-ssh)

- login to a compute node
```bash
idev ## follow the prompts
```

- enable the Singularity environment
```bash
module load tacc-singularity
```

- pull the Singularity image - *this only needs to be done once per version*
```
singularity pull \
    --name hec_ras.sif \
    docker://dhardestylewis/hec_ras_docker:latest
```

*The `hec_ras.sif` file contains the HEC-RAS image.*

- HEC-RAS can now be run from the container:

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


<a name="azure"/>

## **Using TACC's Azure image for HEC-RAS**

Navigate to [TACC's Azure image for HEC-RAS](https://portal.azure.com/#@wmobleyneotamu.onmicrosoft.com/resource/subscriptions/469545af-8403-410f-92e2-6300e77dcb03/resourceGroups/Hecras/providers/Microsoft.Compute/virtualMachines/HecRas-8/overview)

*If you experience an issue accessing this page, please reach out with a screenshot of the error message that you receive.*

Check the `Status` of the virtual machine to see if it is `Running`. If it is not `Running`, click `> Start` to kick it off.

Open the `Connect v` menu and click `Bastion`.

Plug in the `Username` and `Password` that TACC provides and `Connect`.

Enjoy `HEC-RAS` on the cloud!
