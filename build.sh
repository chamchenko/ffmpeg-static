#!/bin/sh

set -e
set -u

jflag=
jval=2
rebuild=0
download_only=0
uname -mpi | grep -qE 'x86|i386|i686' && is_x86=1 || is_x86=0

while getopts 'j:Bd' OPTION
do
  case $OPTION in
  j)
      jflag=1
      jval="$OPTARG"
      ;;
  B)
      rebuild=1
      ;;
  d)
      download_only=1
      ;;
  ?)
      printf "Usage: %s: [-j concurrency_level] (hint: your cores + 20%%) [-B] [-d]\n" $(basename $0) >&2
      exit 2
      ;;
  esac
done
shift $(($OPTIND - 1))

if [ "$jflag" ]
then
  if [ "$jval" ]
  then
    printf "Option -j specified (%d)\n" $jval
  fi
fi

[ "$rebuild" -eq 1 ] && echo "Reconfiguring existing packages..."
[ $is_x86 -ne 1 ] && echo "Not using yasm or nasm on non-x86 platform..."

cd `dirname $0`
ENV_ROOT=`pwd`
. ./env.source

# check operating system
OS=`uname`
platform="unknown"

case $OS in
  'Darwin')
    platform='darwin'
    ;;
  'Linux')
    platform='linux'
    ;;
esac

#if you want a rebuild
#rm -rf "$BUILD_DIR" "$TARGET_DIR"
mkdir -p "$BUILD_DIR" "$TARGET_DIR" "$DOWNLOAD_DIR" "$BIN_DIR"

#download and extract package
download(){
  filename="$1"
  if [ ! -z "$2" ];then
    filename="$2"
  fi
  ../download.pl "$DOWNLOAD_DIR" "$1" "$filename" "$3" "$4"
  #disable uncompress
  REPLACE="$rebuild" CACHE_DIR="$DOWNLOAD_DIR" ../fetchurl "http://cache/$filename"
}

echo "#### FFmpeg static build ####"

#this is our working directory
cd $BUILD_DIR

[ $is_x86 -eq 1 ] && download \
  "yasm-1.3.0.tar.gz" \
  "" \
  "fc9e586751ff789b34b1f21d572d96af" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

[ $is_x86 -eq 1 ] && download \
  "nasm-2.14.02.tar.bz2" \
  "" \
  "3f489aa48ad2aa1f967dc5e293bbd06f" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "OpenSSL_1_0_2o.tar.gz" \
  "" \
  "5b5c050f83feaa0c784070637fac3af4" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "zlib-1.2.11.tar.gz" \
  "" \
  "0095d2d2d1f3442ce1318336637b695f" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "x264-stable.tar.gz" \
  "" \
  "82ad96b9367ab7bab22a2eea1a4702aa" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "x265_2.7.tar.gz" \
  "" \
  "b0d7d20da2a418fa4f53a559946ea079" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "fdk-aac.tar.gz" \
  "" \
  "223d5f579d29fb0d019a775da4e0e061" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

# libass dependency
download \
  "harfbuzz-1.4.6.tar.bz2" \
  "" \
  "e246c08a3bac98e31e731b2a1bf97edf" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "fribidi-1.0.2.tar.bz2" \
  "" \
  "bd2eb2f3a01ba11a541153f505005a7b" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "libass-0.13.6.tar.gz" \
  "" \
  "cd16c45094970cb35b278a8540e203b1" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "lame-3.99.5.tar.gz" \
  "" \
  "84835b313d4a8b68f5349816d33e07ce" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "opus-1.1.2.tar.gz" \
  "" \
  "1f08a661bc72930187893a07f3741a91" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "vpx-1.6.1.tar.gz" \
  "" \
  "b0925c8266e2859311860db5d76d1671" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "rtmpdump-2.3.tgz" \
  "" \
  "eb961f31cd55f0acf5aad1a7b900ef59" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "soxr-0.1.2-Source.tar.xz" \
  "" \
  "0866fc4320e26f47152798ac000de1c0" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "vid.stab-release-0.98b.tar.gz" \
  "" \
  "299b2f4ccd1b94c274f6d94ed4f1c5b8" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "zimg-release-2.7.4.tar.gz" \
  "" \
  "1757dcc11590ef3b5a56c701fd286345" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "openjpeg-2.1.2.tar.gz" \
  "" \
  "40a7bfdcc66280b3c1402a0eb1a27624" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "libwebp-0.6.1.tar.gz" \
  "" \
  "1c3099cd2656d0d80d3550ee29fc0f28" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "vorbis-1.3.6.tar.gz" \
  "" \
  "03e967efb961f65a313459c5d0f4cbfb" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "ogg-1.3.3.tar.gz" \
  "" \
  "b8da1fe5ed84964834d40855ba7b93c2" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "Speex-1.2.0.tar.gz" \
  "" \
  "4bec86331abef56129f9d1c994823f03" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "nv-codec-headers-8.1.24.12.tar.gz" \
  "" \
  "8229b8b6c2227f1b04889a1e538c05af" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "freetype-2.10.2.tar.gz" \
  "" \
  "b1cb620e4c875cd4d1bfa04945400945" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "fontconfig-2.12.1.tar.gz" \
  "" \
  "ce55e525c37147eee14cc2de6cc09f6c" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "opencore-amr-0.1.3.tar.xz" \
  "" \
  "3a0bc1092000dba56819cfaf263b981b" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "vo-amrwbenc-0.1.3.tar.xz" \
  "" \
  "f2103c3a3aee75d6b18a0b61e05046fa" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "xvidcore-1.3.7.tar.gz" \
  "" \
  "cb0059a65c79256433c40f2e45d29e7e" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "frei0r-plugins-1.4.tar.xz" \
  "" \
  "2e0313769765aba613bb0f03b4d198b7" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"

download \
  "n4.3.1.tar.gz" \
  "" \
  "426ca412ca61634a248c787e29507206" \
  "https://github.com/chamchenko/ffmpeg-static/raw/master/libs/"





[ $download_only -eq 1 ] && exit 0

TARGET_DIR_SED=$(echo $TARGET_DIR | awk '{gsub(/\//, "\\/"); print}')

if [ $is_x86 -eq 1 ]; then
    echo "*** Building yasm ***"
    cd $BUILD_DIR/yasm*
    [ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
    [ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --bindir=$BIN_DIR
    make -j $jval
    make install
fi

if [ $is_x86 -eq 1 ]; then
    echo "*** Building nasm ***"
    cd $BUILD_DIR/nasm*
    [ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
    [ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --bindir=$BIN_DIR
    make -j $jval
    make install
fi

echo "*** Building OpenSSL ***"
cd $BUILD_DIR/openssl*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
if [ "$platform" = "darwin" ]; then
  PATH="$BIN_DIR:$PATH" ./Configure darwin64-x86_64-cc --prefix=$TARGET_DIR
elif [ "$platform" = "linux" ]; then
  PATH="$BIN_DIR:$PATH" ./config --prefix=$TARGET_DIR
fi
PATH="$BIN_DIR:$PATH" make -j $jval
make install

echo "*** Building freetype ***"
cd $BUILD_DIR/freetype*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure
make -j $jval
make install

echo "*** Building fontconfig ***"
cd $BUILD_DIR/fontconfig*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --disable-shared
make -j $jval
make install

echo "*** Building fontconfig ***"
cd $BUILD_DIR/fontconfig*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building zlib ***"
cd $BUILD_DIR/zlib*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
if [ "$platform" = "linux" ]; then
  [ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR
elif [ "$platform" = "darwin" ]; then
  [ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR
fi
PATH="$BIN_DIR:$PATH" make -j $jval
make install

echo "*** Building x264 ***"
cd $BUILD_DIR/x264*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR --enable-static --disable-shared --disable-opencl --enable-pic
PATH="$BIN_DIR:$PATH" make -j $jval
make install

echo "*** Building x265 ***"
cd $BUILD_DIR/x265*
cd build/linux
[ $rebuild -eq 1 ] && find . -mindepth 1 ! -name 'make-Makefiles.bash' -and ! -name 'multilib.sh' -exec rm -r {} +
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DENABLE_SHARED:BOOL=OFF -DSTATIC_LINK_CRT:BOOL=ON -DENABLE_CLI:BOOL=OFF ../../source
sed -i 's/-lgcc_s/-lgcc_eh/g' x265.pc
make -j $jval
make install

echo "*** Building fdk-aac ***"
cd $BUILD_DIR/fdk-aac*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
autoreconf -fiv
[ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building harfbuzz ***"
cd $BUILD_DIR/harfbuzz-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --disable-shared --enable-static
make -j $jval
make install

echo "*** Building fribidi ***"
cd $BUILD_DIR/fribidi-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --disable-shared --enable-static --disable-docs
make -j $jval
make install

echo "*** Building libass ***"
cd $BUILD_DIR/libass-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building mp3lame ***"
cd $BUILD_DIR/lame*
# The lame build script does not recognize aarch64, so need to set it manually
uname -a | grep -q 'aarch64' && lame_build_target="--build=arm-linux" || lame_build_target=''
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --enable-nasm --disable-shared $lame_build_target
make
make install

echo "*** Building opus ***"
cd $BUILD_DIR/opus*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --disable-shared
make
make install

echo "*** Building libvpx ***"
cd $BUILD_DIR/libvpx*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && PATH="$BIN_DIR:$PATH" ./configure --prefix=$TARGET_DIR --disable-examples --disable-unit-tests --enable-pic
PATH="$BIN_DIR:$PATH" make -j $jval
make install

echo "*** Building librtmp ***"
cd $BUILD_DIR/rtmpdump-*
cd librtmp
[ $rebuild -eq 1 ] && make distclean || true

# there's no configure, we have to edit Makefile directly
if [ "$platform" = "linux" ]; then
  sed -i "/INC=.*/d" ./Makefile # Remove INC if present from previous run.
  sed -i "s/prefix=.*/prefix=${TARGET_DIR_SED}\nINC=-I\$(prefix)\/include/" ./Makefile
  sed -i "s/SHARED=.*/SHARED=no/" ./Makefile
elif [ "$platform" = "darwin" ]; then
  sed -i "" "s/prefix=.*/prefix=${TARGET_DIR_SED}/" ./Makefile
fi
make install_base

echo "*** Building libsoxr ***"
cd $BUILD_DIR/soxr-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off -DWITH_OPENMP:bool=off -DBUILD_TESTS:bool=off
make -j $jval
make install

echo "*** Building libvidstab ***"
cd $BUILD_DIR/vid.stab-release-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
if [ "$platform" = "linux" ]; then
  sed -i "s/vidstab SHARED/vidstab STATIC/" ./CMakeLists.txt
elif [ "$platform" = "darwin" ]; then
  sed -i "" "s/vidstab SHARED/vidstab STATIC/" ./CMakeLists.txt
fi
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR"
make -j $jval
make install

echo "*** Building openjpeg ***"
cd $BUILD_DIR/openjpeg-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
PATH="$BIN_DIR:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" -DBUILD_SHARED_LIBS:bool=off
make -j $jval
make install

echo "*** Building zimg ***"
cd $BUILD_DIR/zimg-release-*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --enable-static  --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building libwebp ***"
cd $BUILD_DIR/libwebp*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building libvorbis ***"
cd $BUILD_DIR/vorbis*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building libogg ***"
cd $BUILD_DIR/ogg*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building libspeex ***"
cd $BUILD_DIR/speex*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./autogen.sh
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building nv-codec ***"
cd $BUILD_DIR/nv-codec*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
sed -i "s#\/usr\/local#$TARGET_DIR#g" Makefile
make -j $jval
make install

echo "*** Building fontconfig ***"
cd $BUILD_DIR/fontconfig*
[ $rebuild -eq 1 -a -f Makefile ] || true
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building opencore ***"
cd $BUILD_DIR/opencore*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building vo-amrwbenc ***"
cd $BUILD_DIR/vo-amrwbenc*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
autoreconf -fiv
[ ! -f config.status ] && ./configure --prefix=$TARGET_DIR --disable-shared
make -j $jval
make install

echo "*** Building xvidcore ***"
cd $BUILD_DIR/xvidcore*
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
[ ! -f config.status ] && ./configure --prefix=$TARGET_DIR
make -j $jval
make install

echo "*** Building frei0r-plugins ***"
cd $BUILD_DIR/frei0r*
mkdir build && cd build
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true
cmake -DCMAKE_INSTALL_PREFIX=$TARGET_DIR -DCMAKE_BUILD_TYPE=Release -DWITHOUT_OPENCV=TRUE -Wno-dev ..
make -j $jval
make install

# FFMpeg
echo "*** Building FFmpeg ***"
cd $BUILD_DIR/FFmpeg*
sed -i "s#_flags_filter\=echo#_flags_filter\='filter_out\ \-lm\|\-ldl'#g" configure
[ $rebuild -eq 1 -a -f Makefile ] && make distclean || true

if [ "$platform" = "linux" ]; then
  [ ! -f config.status ] && PATH="$BIN_DIR:$PATH" \
  PKG_CONFIG_PATH="$TARGET_DIR/lib/pkgconfig" ./configure \
    --prefix="$TARGET_DIR" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$TARGET_DIR/include" \
    --extra-ldflags="-L$TARGET_DIR/lib" \
    --extra-libs="-Wl,-Bdynamic -lm -ldl -lpthread -lm -lz " \
    --extra-ldexeflags="-Wl,-Bstatic" \
    --extra-version=CHAMCHENKO \
    --bindir="$BIN_DIR" \
    --enable-pic \
    --disable-ffplay \
    --enable-fontconfig \
    --enable-frei0r \
    --enable-ffnvcodec \
    --enable-cuvid \
    --enable-nvenc \
    --enable-gpl \
    --enable-version3 \
    --enable-libass \
    --enable-libfribidi \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopencore-amrnb \
    --enable-libopencore-amrwb \
    --enable-libopenjpeg \
    --enable-libopus \
    --enable-librtmp \
    --enable-libsoxr \
    --enable-libspeex \
    --enable-libtheora \
    --enable-libvidstab \
    --enable-libvo-amrwbenc \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libxvid \
    --enable-libzimg \
    --enable-nonfree \
    --enable-openssl
elif [ "$platform" = "darwin" ]; then
  [ ! -f config.status ] && PATH="$BIN_DIR:$PATH" \
  PKG_CONFIG_PATH="${TARGET_DIR}/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:/usr/local/Cellar/openssl/1.0.2o_1/lib/pkgconfig" ./configure \
    --cc=/usr/bin/clang \
    --prefix="$TARGET_DIR" \
    --pkg-config-flags="--static" \
    --extra-cflags="-I$TARGET_DIR/include" \
    --extra-ldflags="-L$TARGET_DIR/lib" \
    --extra-libs="-lpthread -lm -lz -Wl,-Bdynamic -lm -ldl" \
    --extra-ldexeflags="-Wl,-Bstatic" \
    --extra-version=CHAMCHENKO \
    --bindir="$BIN_DIR" \
    --enable-pic \
    --disable-ffplay \
    --enable-fontconfig \
    --enable-frei0r \
    --enable-ffnvcodec \
    --enable-cuvid \
    --enable-nvenc \
    --enable-gpl \
    --enable-version3 \
    --enable-libass \
    --enable-libfribidi \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libmp3lame \
    --enable-libopencore-amrnb \
    --enable-libopencore-amrwb \
    --enable-libopenjpeg \
    --enable-libopus \
    --enable-librtmp \
    --enable-libsoxr \
    --enable-libspeex \
    --enable-libtheora \
    --enable-libvidstab \
    --enable-libvo-amrwbenc \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libxvid \
    --enable-libzimg \
    --enable-nonfree \
    --enable-openssl
fi

PATH="$BIN_DIR:$PATH" make -j $jval
make install
make distclean
hash -r
