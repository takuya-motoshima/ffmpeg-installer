#!/bin/sh

# Install FFmpeg dependency library
sudo yum -y install\
  autoconf\
  automake\
  cmake\
  freetype-devel\
  gcc\
  gcc-c++\
  git\
  libtool\
  make\
  mercurial\
  pkgconfig\
  zlib-devel;

#alias make='make -j 4'

# In order to incorporate the AV1 encoder, cmake version 3.5 or higher is required, so update if cmake version is less than 3.5
cmake_version=`cmake --version | head -1 | awk -F " " '{print $3}'`;
cmake_major_version=`echo $cmake_version | cut -d. -f1`;
cmake_minor_version=`echo $cmake_version | cut -d. -f2`;
if [ $cmake_major_version -lt 3 -o \( $cmake_major_version -eq 3 -a $cmake_minor_version -lt 5 \) ]; then
  echo "old CMake version $cmake_version found, a new one must be used"
  sudo yum -y remove cmake;
  cd ~;
  wget https://cmake.org/files/v3.16/cmake-3.14.3.tar.gz;
  tar -xvzf cmake-3.14.3.tar.gz;
  cd cmake-3.14.3;
  ./bootstrap;
  make;
  sudo make install;
fi

# Create FFmpeg installation directory
mkdir ~/ffmpeg_sources;

# Install Yasm required to install x264 encoder
cd ~/ffmpeg_sources
git clone --depth 1 git://github.com/yasm/yasm.git
cd yasm
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install

# Install nasm required to install x264 encoder
cd ~/ffmpeg_sources
wget https://www.nasm.us/pub/nasm/releasebuilds/2.14rc15/nasm-2.14rc15.tar.xz
tar xvfJ nasm-2.14rc15.tar.xz
cd nasm-2.14rc15
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install

# Install x264 encoder
cd ~/ffmpeg_sources
git clone --depth 1 git://git.videolan.org/x264
cd x264
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make
make install

# Install x265 encoder
cd ~/ffmpeg_sources
hg clone https://bitbucket.org/multicoreware/x265
cd ~/ffmpeg_sources/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off ../../source
make
make install

# Install AAC encoder
cd ~/ffmpeg_sources
git clone --depth 1 git://git.code.sf.net/p/opencore-amr/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install

# Install LAME encoder
cd ~/ffmpeg_sources
curl -O -L http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xzvf lame-3.100.tar.gz
cd lame-3.100
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm
make
make install

# Install Opus encoder
cd ~/ffmpeg_sources
git clone http://git.opus-codec.org/opus.git
cd opus
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install

# Install Ogg encoder
cd ~/ffmpeg_sources
curl -O https://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.3.tar.gz
tar xzvf libogg-1.3.3.tar.gz
cd libogg-1.3.3
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install

# Install Vorbis encoder
cd ~/ffmpeg_sources
curl -O https://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.6.tar.gz
tar xzvf libvorbis-1.3.6.tar.gz
cd libvorbis-1.3.6
LDFLAGS="-L$HOME/ffmeg_build/lib" CPPFLAGS="-I$HOME/ffmpeg_build/include" ./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --disable-shared
make
make install

# Install VPX encoder
cd ~/ffmpeg_sources
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="$HOME/ffmpeg_build" --disable-examples
make
make install

# Install AV1 encoder
cd ~/ffmpeg_sources
git clone --depth 1 https://aomedia.googlesource.com/aom
mkdir aom_build
cd aom_build
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off -DENABLE_NASM=on ../aom
make
make install

# Install FFmpeg
cd ~/ffmpeg_sources
git clone http://source.ffmpeg.org/git/ffmpeg.git
cd ffmpeg
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig:$HOME/ffmpeg_build/lib64/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --extra-cflags="-I$HOME/ffmpeg_build/include" --extra-ldflags="-L$HOME/ffmpeg_build/lib" --bindir="$HOME/bin" --pkg-config-flags="--static" --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-libaom --extra-libs=-lpthread --extra-libs=-lm
make
make install
hash -r
