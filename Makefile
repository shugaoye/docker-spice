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
# Makefile - Make file for the docker build
#
# Copyright (c) 2017 Roger Ye.  All rights reserved.
#
#******************************************************************************
#
# Makefile to build and test docker containers
#   VOL1 - the one used to build source code
#   VOL2 - the one used to store build cache
# Both can be defined in your environment, otherwise the below default values
# will be used.

TAG_NAME = ubuntu16.04_qemu-n
DOCKER = docker
IMAGE = shugaoye/docker-spice:$(TAG_NAME)
VOL1 ?= $(HOME)/vol1
VOL2 ?= $(HOME)/.ccache
USER_ID := $(shell id -u)
GROUP_ID := $(shell id -g)
BUILD_ROOT ?= /home/aosp/qemu_android

all: Dockerfile
	$(DOCKER) build -t $(IMAGE) .

run:
	$(DOCKER) run --privileged --name "$(TAG_NAME)-v1" -v /tmp/.X11-unix:/tmp/.X11-unix:ro -v "$(VOL1):/home/aosp" \
	-v "$(VOL2):/tmp/ccache" -it -e DISPLAY=$(DISPLAY) -e USER_ID=$(USER_ID) -e GROUP_ID=$(GROUP_ID) \
	$(IMAGE) /bin/bash

.PHONY: all

# The following build targets can only run inside containers.
spice-protocol:
	./build_script.sh spice-protocol

spice:
	./build_script.sh spice

spice-gtk:
	./build_script.sh spice-gtk

virt-viewer:
	./build_script.sh virt-viewer

virglrenderer:
	./build_script.sh virglrenderer

celt:
	./build_script.sh celt
	
qemu:
	./build_script.sh qemu

# The following build targets can run from the host.
docker-spice-protocol:
	$(DOCKER) run --rm --name "$(TAG_NAME)_spice-protocol" -v "$(VOL1):/home/aosp" \
	-v "$(VOL2):/tmp/ccache" -it -e USER_ID=$(USER_ID) -e GROUP_ID=$(GROUP_ID) \
	$(IMAGE) $(BUILD_ROOT)/src/docker-spice/build_script.sh spice-protocol $(BUILD_ROOT)

docker-spice:
	$(DOCKER) run --rm --name "$(TAG_NAME)_spice" -v "$(VOL1):/home/aosp" \
	-v "$(VOL2):/tmp/ccache" -it -e USER_ID=$(USER_ID) -e GROUP_ID=$(GROUP_ID) \
	$(IMAGE) $(BUILD_ROOT)/src/docker-spice/build_script.sh spice $(BUILD_ROOT)

docker-spice-gtk:
	$(DOCKER) run --rm --name "$(TAG_NAME)_spice-gtk" -v "$(VOL1):/home/aosp" \
	-v "$(VOL2):/tmp/ccache" -it -e USER_ID=$(USER_ID) -e GROUP_ID=$(GROUP_ID) \
	$(IMAGE) $(BUILD_ROOT)/src/docker-spice/build_script.sh spice-gtk $(BUILD_ROOT)

docker-virt-viewer:
	$(DOCKER) run --rm --name "$(TAG_NAME)_spice" -v "$(VOL1):/home/aosp" \
	-v "$(VOL2):/tmp/ccache" -it -e USER_ID=$(USER_ID) -e GROUP_ID=$(GROUP_ID) \
	$(IMAGE) $(BUILD_ROOT)/src/docker-spice/build_script.sh virt-viewer $(BUILD_ROOT)

docker-virglrenderer:
	$(DOCKER) run --rm --name "$(TAG_NAME)_spice" -v "$(VOL1):/home/aosp" \
	-v "$(VOL2):/tmp/ccache" -it -e USER_ID=$(USER_ID) -e GROUP_ID=$(GROUP_ID) \
	$(IMAGE) $(BUILD_ROOT)/src/docker-spice/build_script.sh virglrenderer $(BUILD_ROOT)

docker-qemu:
	$(DOCKER) run --rm --name "$(TAG_NAME)_spice" -v "$(VOL1):/home/aosp" \
	-v "$(VOL2):/tmp/ccache" -it -e USER_ID=$(USER_ID) -e GROUP_ID=$(GROUP_ID) \
	$(IMAGE) $(BUILD_ROOT)/src/docker-spice/build_script.sh qemu $(BUILD_ROOT)
