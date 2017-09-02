#
# Makefile to build and test docker containers
#   VOL1 - the one used to build source code
#   VOL2 - the one used to store build cache
# Both can be defined in your environment, otherwise the below default values
# will be used.

DOCKER = docker
IMAGE = shugaoye/docker-spice:fedora26
VOL1 ?= $(HOME)/vol1
VOL2 ?= $(HOME)/.ccache
USER_ID := $(shell id -u)
GROUP_ID := $(shell id -g)

all: Dockerfile
	$(DOCKER) build -t $(IMAGE) .

run:
	$(DOCKER) run --name "fedora26-spice" -v "$(VOL1):/home/aosp" -v "$(VOL2):/tmp/ccache" -it -e USER_ID=$(USER_ID) -e GROUP_ID=$(GROUP_ID) $(IMAGE) /bin/bash

.PHONY: all
