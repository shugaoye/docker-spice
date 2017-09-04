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

ENV PACKAGES \
    ccache git tar PyYAML sparse flex bison python2 bzip2 hostname \
    glib2-devel pixman-devel zlib-devel SDL-devel libfdt-devel \
    gcc gcc-c++ clang make perl which bc findutils libaio-devel \
    mingw32-pixman mingw32-glib2 mingw32-gmp mingw32-SDL mingw32-pkg-config \
    mingw32-gtk2 mingw32-gtk3 mingw32-gnutls mingw32-nettle mingw32-libtasn1 \
    mingw32-libjpeg-turbo mingw32-libpng mingw32-curl mingw32-libssh2 \
    mingw32-bzip2 \
    mingw64-pixman mingw64-glib2 mingw64-gmp mingw64-SDL mingw64-pkg-config \
    mingw64-gtk2 mingw64-gtk3 mingw64-gnutls mingw64-nettle mingw64-libtasn1 \
    mingw64-libjpeg-turbo mingw64-libpng mingw64-curl mingw64-libssh2 \
    mingw64-bzip2

RUN dnf -y update && \
		dnf -y builddep virglrenderer

RUN dnf -y install $PACKAGES
RUN rpm -q $PACKAGES | sort > /packages.txt
ENV FEATURES mingw clang pyyaml

ENTRYPOINT ["/root/docker_entrypoint.sh"]
