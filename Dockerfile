#
# Minimum Docker image to build SPICE
#
FROM fedora:26

MAINTAINER Roger Ye <shugaoye@yahoo.com>

RUN dnf -y update && \
	dnf -y install 'dnf-command(builddep)'

RUN	dnf -y builddep spice-gtk

RUN dnf -y install openssh-server passwd sudo \ 
    	wget vim git redhat-rpm-config gstreamer1-plugins-good gstreamer-plugins-bad-free \
    	orc-devel pyparsing gtk-vnc-devel

# RUN export LC_ALL=C
# RUN pip install pyomo -U
RUN dnf clean all

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
ENTRYPOINT ["/root/docker_entrypoint.sh"]
