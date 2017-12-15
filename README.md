ARM Trusted Firmware (ATF) is a reference implementation of the bootloader which can 
support TrustZone from ARM. According to the document at GitHub, ATF supports QEMU as
a testing platform so that the developers can test it without a hardware board.

ATF can boot up secure OS in the secure world including OP-TEE, Trusty and Trusted Little
Kernel etc. Please refer to the [Firmware Desgin](https://github.com/ARM-software/arm-trusted-firmware/docs/firmware-design.rst) for more information on how the Trusted Firmware works.

To build and test ATF, it is not a straightforward task for most of people. Even though, there are enough documents at the [ATF GitHub](https://github.com/ARM-software/arm-trusted-firmware), but it is still a challenging task to setup the build and run the test.

To help the setup of ATF build and test, I built ATF and test it in docker containers. You can just pull the docker images to build and test ATF. From there, you can dig into the code to find out more about it.

Docker image for ATF build
==========================
The docker image for the ATF build can be pulled from Docker Hub using the below command:

    $ docker pull shugaoye/docker-spice:op-tee

The image ``shugaoye/docker-spice`` is an image to build AOSP, QEMU and SPICE etc. I created 
a branch [op-tee](https://github.com/shugaoye/docker-spice/tree/op-tee) for the ATF and op-tee build. To start a container, you can checkout the source code
and run ``make`` command as below:

    $ git clone https://github.com/shugaoye/docker-spice.git -b op-tee
    $ make run

You can refer to the ``Makefile`` to find out the details about how to build the Docker image and
how to start a container for the ATF build environment. You can make changes to the Makefile
or set the environment variable VOL1 to define a Docker volume which can be used for the build.
After you start the container, the home folder ``/home/aosp`` is the mount pointer of Docker volume.
You can get the ATF code the build ATF under ``/home/aosp``. Please refer to the ATF documents about
the build procedure.

Docker image to test ATF build
==============================
The environment for ATF testing is a little different from the one for the build. I created another
[Docker image](https://hub.docker.com/r/shugaoye/atf/) which included everything that you need to run ATF build in QEMU.

To test ATF build, you can pull the below Docker image:

    $ docker pull shugaoye/atf:latest

After you download the image, you can start a container using the below script:

    #!/usr/bin/env bash

    CUR_USER=`id -u`
    CUR_GROUP=`id -g`

    docker run --privileged --name 'shugaoye_atf' -v /tmp/.X11-unix:/tmp/.X11-unix:ro \
    -it -e DISPLAY=$DISPLAY -e USER_ID=${CUR_USER} -e GROUP_ID=${CUR_GROUP} \
    shugaoye/atf /bin/bash

After you start the container, you can boot QEMU virt using ATF with the below
command:

    $ ../optee/bin/run_atf.sh

To run the above script, you need to make sure the X11 is properly configured on your host
environment. To test it, you can just run ``xterm`` from the container and see whether it 
works properly or not.

In this image, secure EL1 payload is not included. I need to do more work to build OP-TEE, 
Trusty or other TrustZone OS for QEMU later. The Non Secure OS bootloader is EFI image 
QEMU_EFI.fd from Linaro according to [ATF QEMU document](https://github.com/ARM-software/arm-trusted-firmware/blob/master/docs/plat/qemu.rst).
