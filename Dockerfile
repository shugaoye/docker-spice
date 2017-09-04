# Copyright (C) 2017 the base image for QEMU and SPICE build environment using docker
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#******************************************************************************
#
# Dockerfile - The base docker file which can be extended
#
# Copyright (c) 2017 Roger Ye.  All rights reserved.
#
#******************************************************************************
#
#
# Minimum Docker image to build SPICE
#
FROM centos:7

MAINTAINER Roger Ye <shugaoye@yahoo.com>

RUN yum -y install yum-utils
RUN	yum-builddep -y qemu-guest-agent qemu-img qemu-kvm qemu-kvm-common qemu-kvm-tools spice-gtk

RUN yum -y install openssh-server passwd sudo \ 
    	wget vim git redhat-rpm-config gstreamer1-plugins-good gstreamer-plugins-bad-free \
    	orc-devel pyparsing gtk-vnc-devel gdb ddd

RUN export LC_ALL=C
# RUN pip install pyomo -U
RUN yum clean all

# Configure environment, such as SSH etc.
RUN echo 'root:root' | chpasswd

# install and configure SSH server
RUN /usr/bin/ssh-keygen -A
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

EXPOSE 22

CMD    ["/usr/sbin/sshd", "-D"]

# The persistent data will be in these two directories, everything else is
# considered to be ephemeral
VOLUME ["/tmp/ccache", "/home/aosp"]

# Improve rebuild performance by enabling compiler cache
ENV USE_CCACHE 1
ENV CCACHE_DIR /tmp/ccache

# Work in the build directory, repo is expected to be init'd here
WORKDIR /home/aosp

COPY utils/bash.bashrc /root/bash.bashrc
RUN chmod 755 /root /root/bash.bashrc
COPY utils/setup_build.sh /root/setup_build.sh
RUN chmod 755 /root/setup_build.sh
COPY utils/docker_entrypoint.sh /root/docker_entrypoint.sh
# This entrypoint is not used in the base version. 
# ENTRYPOINT ["/root/docker_entrypoint.sh"]
