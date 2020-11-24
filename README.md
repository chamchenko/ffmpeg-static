FFmpeg with nvenc build
===================
This is not a completly static build.
If all goes well, at the end you have a ffmpeg binary with everything statically linked except the glibc and dynamic linker, with working NVIDIA support.
The binary will work on any linux system running a newer version of glibc than the one used on the build system. (that is why I'm using ubuntu 14.04 on the docker image as it gives me more coverage)
Build dependencies
------------------

    # Debian & Ubuntu
    $ apt-get install autoconf automake build-essential cmake libfreetype6-dev frei0r-plugins-dev libgpac-dev libsdl1.2-dev libtheora-dev libtool \
    libva-dev libvdpau-dev libvo-amrwbenc-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texi2html libexpat1-dev \
    zlib1g-dev libvpx-dev libxvidcore-dev libharfbuzz-dev libfontconfig-dev libopencore-amrnb-dev libopencore-amrwb-dev git wget gawk libass-dev\
    libwebp-dev curl tar libspeex-dev libssl-dev gperf

Build & "install"
-----------------

    $ ./build.sh [-j <jobs>] [-B] [-d]
    # ... wait ...
    # binaries can be found in ./target/bin/

Ubuntu users can download dependencies and and install in one command:

    $ sudo ./build-ubuntu.sh

If you have built ffmpeg before with `build.sh`, the default behaviour is to keep the previous configuration. If you would like to reconfigure and rebuild all packages, use the `-B` flag. `-d` flag will only download and unpack the dependencies but not build.

NOTE: If you're going to use the h264 presets, make sure to copy them along the binaries. For ease, you can put them in your home folder like this:

    $ mkdir ~/.ffmpeg
    $ cp ./target/share/ffmpeg/*.ffpreset ~/.ffmpeg


Build in docker
---------------

    $ docker build -t ffmpeg-static .
    $ docker run -it ffmpeg-static
    $ ./build.sh [-j <jobs>] [-B] [-d]

The binaries will be created in `bin` directory.
Method of getting them out of the Docker container is up to you.
`/ffmpeg-static` is a Docker volume.
