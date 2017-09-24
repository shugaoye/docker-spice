AOSP/QEMU/SPICE Build Environment in Docker
====================================================

This build environment is based on Ubuntu 16.04.

How to build it
---------------

There are multiple targets in the Makefile. To build it, just checkout the repository
and run the below command:
$ make


How to start a container
------------------------

You can use the below command to launch a container.
$ make run

This target executes the below command:
$ docker run -v "$(VOL1):/root" -v "$(VOL2):/tmp/ccache" -it -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) $(IMAGE) /bin/bash

It will set two data volumes. 
VOL1 - the working directory for the build
VOL2 - the cache directory for ccache

You can define your own user and group using environment varialbles or it will setup the current user in the container.

History
-------
20170924 - Changed bash.bashrc. Added telnet and mc to image.
