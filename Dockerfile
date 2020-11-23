FROM ubuntu:trusty

RUN apt-get update && apt-get -y --force-yes install autoconf \
  automake \
  build-essential \
  cmake \
  libfreetype6-dev \
  frei0r-plugins-dev \
  libgpac-dev \
  libsdl1.2-dev \
  libtheora-dev \
  libtool \
  libva-dev \
  libvdpau-dev \
  libvo-amrwbenc-dev \
  libvorbis-dev \
  libxcb1-dev \
  libxcb-shm0-dev \
  libxcb-xfixes0-dev \
  pkg-config \
  texi2html \
  libexpat1-dev \
  zlib1g-dev \
  libvpx-dev \
  libxvidcore-dev \
  libharfbuzz-dev \
  libfontconfig-dev \
  libopencore-amrnb-dev \
  libopencore-amrwb-dev \
  git \
  wget \
  gawk \
  libass-dev\
  libwebp-dev \
  curl \
  tar \
  libspeex-dev \
  libssl-dev \
  gperf \
  && rm -rf /var/lib/apt/lists/*

# Copy the build scripts.
COPY build.sh download.pl env.source fetchurl /FFMPEG-CHAMCHENKO/

VOLUME /FFMPEG-CHAMCHENKO
WORKDIR /FFMPEG-CHAMCHENKO
CMD /bin/bash
