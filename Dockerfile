#
# Minimum Docker image to build Android AOSP
#
FROM shugaoye/docker-aosp:ubuntu14.04-JDK7

MAINTAINER Roger Ye <shugaoye@yahoo.com>

# install and configure SSH server
RUN apt-get update
RUN apt-get install -y openssh-server net-tools gettext vim-common vim-tiny python-pip libxml2-dev \
	libtext-csv-perl libglib2.0-dev gtk-doc-tools libpixman-1-dev libgtk-3-dev libjpeg-dev valac libssl-dev
RUN mkdir /var/run/sshd
RUN export LC_ALL=C

RUN pip install pyomo -U
RUN echo 'root:root' |chpasswd

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
