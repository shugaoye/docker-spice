#!/usr/bin/env bash

CUR_USER=`id -u`
CUR_GROUP=`id -g`

docker run --privileged --name 'shugaoye_atf' -v /tmp/.X11-unix:/tmp/.X11-unix:ro -it -e DISPLAY=$DISPLAY -e USER_ID=${CUR_USER} -e GROUP_ID=${CUR_GROUP} shugaoye/atf /bin/bash
