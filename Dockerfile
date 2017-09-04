# Copyright (C) 2017 SPICE and QEMU build environment using docker
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
# Dockerfile - The docker file for SPICE and QEMU build
#
# Copyright (c) 2017 Roger Ye.  All rights reserved.
#
#******************************************************************************
#

FROM shugaoye/docker-spice:fedora26_base

MAINTAINER Roger Ye <shugaoye@yahoo.com>

RUN dnf -y update && \
		dnf -y builddep qemu

# RUN dnf -y install openssh-server passwd sudo \ 
#    	wget vim git redhat-rpm-config gstreamer1-plugins-good gstreamer-plugins-bad-free \
#    	orc-devel pyparsing gtk-vnc-devel gdb ddd


ENTRYPOINT ["/root/docker_entrypoint.sh"]
