#!/bin/sh

# Uninstall Yasm
cd ~/ffmpeg_sources/yasm;
sudo make uninstall;

# Uninstall nasm
# cd ~/ffmpeg_sources/nasm-2.14rc15;
# sudo make uninstall;

# Uninstall x264 encoder
# cd ~/ffmpeg_sources/x264;
# sudo make uninstall;

# Uninstall x265 encoder
cd ~/ffmpeg_sources/x265/build/linux;
make uninstall;

# Uninstall AAC encoder
# cd ~/ffmpeg_sources/fdk-aac;
# make uninstall;

# Uninstall LAME encoder
cd ~/ffmpeg_sources/lame-3.100;
make uninstall;

# Uninstall Opus encoder
cd ~/ffmpeg_sources/opus;
make uninstall;

# Uninstall Ogg encoder
cd ~/ffmpeg_sources/libogg-1.3.3;
make uninstall;

# Uninstall Vorbis encoder
cd ~/ffmpeg_sources/libvorbis-1.3.6;
make uninstall;

# Uninstall VPX encoder
# cd ~/ffmpeg_sources/libvpx;
# make uninstall;

# Uninstall AV1 encoder
# cd ~/ffmpeg_sources/aom_build;
# make uninstall;

# Uninstall FFmpeg
cd ~/ffmpeg_sources/ffmpeg;
make uninstall;
