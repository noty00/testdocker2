FROM ubuntu:16.04

RUN apt-get update && apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping libsdl1.2-dev xterm

RUN apt-get install -y sudo vim

RUN useradd -ms /bin/bash developer
RUN echo 'developer:developer' | chpasswd && adduser developer sudo

# Fix error "Please use a locale setting which supports utf-8."
# See https://wiki.yoctoproject.org/wiki/TipsAndTricks/ResolvingLocaleIssues
RUN apt-get install -y locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
dpkg-reconfigure --frontend=noninteractive locales && \
update-locale LANG=en_US.UTF-8

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

USER developer
WORKDIR /home/developer
RUN git clone git://git.yoctoproject.org/poky
RUN cd poky && git checkout tags/yocto-2.4.2 -b poky_2.4.2