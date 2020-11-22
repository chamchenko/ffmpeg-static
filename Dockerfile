FROM ubuntu:trusty

RUN apt-get update && apt-get -y --force-yes install autoconf automake build-essential libfreetype6-dev libgpac-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texi2html zlib1g-dev libvpx-dev \
  libharfbuzz-dev libfontconfig-dev  git wget gperf \
  && rm -rf /var/lib/apt/lists/*

# Copy the build scripts.
COPY build-ubuntu.sh build.sh download.pl env.source fetchurl /FFMPEG-CHAMCHENKO/

VOLUME /FFMPEG-CHAMCHENKO
WORKDIR /FFMPEG-CHAMCHENKO
CMD /bin/bash
