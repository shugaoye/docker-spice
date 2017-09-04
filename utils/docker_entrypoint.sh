#!/bin/bash
set -e

# This script designed to be used a docker ENTRYPOINT "workaround" missing docker
# feature discussed in docker/docker#7198, allow to have executable in the docker
# container manipulating files in the shared volume owned by the USER_ID:GROUP_ID.
#
# It creates a default user with selected USER_ID and GROUP_ID (or
# 1000 if not specified).

# Example:
#
#  docker run -ti -e USER_ID=$(id -u) -e GROUP_ID=$(id -g) imagename bash
#

USER_NAME=qemu

# Reasonable defaults if no USER_ID/GROUP_ID environment variables are set.
if [ -z ${USER_ID+x} ]; then USER_ID=1000; fi
if [ -z ${GROUP_ID+x} ]; then GROUP_ID=1000; fi

# ccache
export CCACHE_DIR=/tmp/ccache
export USE_CCACHE=1

msg="docker_entrypoint: Creating user UID/GID [$USER_ID/$GROUP_ID]" && echo $msg
groupadd -g $GROUP_ID -r ${USER_NAME} && \
useradd -u $USER_ID --create-home -r -g ${USER_NAME} ${USER_NAME}
echo "$msg - done"

# Enable sudo for the default user
echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers

/usr/sbin/sshd -D &

msg="docker_entrypoint: Creating /tmp/ccache and /home/${USER_NAME} directory" && echo $msg
mkdir -p /tmp/ccache
chown ${USER_NAME}:${USER_NAME} /tmp/ccache
echo "$msg - done"

echo ""

# Default to 'bash' if no arguments are provided
args="$@"
if [ -z "$args" ]; then
  args="bash"
fi

# Execute command as default user
export HOME=/home/${USER_NAME}
echo '${USER_NAME}:${USER_NAME}' | chpasswd
exec sudo -E -u ${USER_NAME} $args --init-file /root/bash.bashrc
