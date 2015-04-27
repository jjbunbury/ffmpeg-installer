#!/bin/bash
#
#  encoder installation script
#
#  Copyright (C) 2010 - 2014 Dazzle Software, LLC. All rights reserved.
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

#######################################################################
# colour
#######################################################################
GREEN='\033[01;32m'
RED='\033[01;31m'
RESET='\033[0m'
#######################################################################
# source
#######################################################################
SOURCE_DIR='/usr/local/src'
SOURCE_DOWNLOAD_URL='http://encoder.dazzlesoftware.org/files'
#######################################################################
# install
#######################################################################
PREFIX_DIR='/usr/local/encoder'
#######################################################################
# environment variables
#######################################################################
export PATH=$PREFIX_DIR/bin:$PATH
export CPATH=$PREFIX_DIR/include:$CPATH
export LD_LIBRARY_PATH=$PREFIX_DIR/lib:$LD_LIBRARY_PATH
export LIBRARY_PATH=$PREFIX_DIR/lib:$LIBRARY_PATH
#######################################################################
# flags
#######################################################################
INCLUDE_DIRECTORY=$PREFIX_DIR/include
LIBRARY_DIRECTORY=$PREFIX_DIR/lib
#######################################################################
# export
#######################################################################
export PROCESSOR=`cat "/proc/cpuinfo" | grep "processor" | wc -l`
export TMPDIR=$HOME/tmp
export PKG_CONFIG_PATH=$PREFIX_DIR/lib/pkgconfig
export LDFLAGS=-L$LIBRARY_DIRECTORY
export CPPFLAGS=-I$INCLUDE_DIRECTORY
#######################################################################
# miscellaneous export
#######################################################################
#######################################################################
# package
#######################################################################
package='ffmpeg'
version='2.6.1'
extension='tar.bz2'
#######################################################################
# Detect platform
#######################################################################
PLATFORM=`uname`
#######################################################################
# tar tools
#######################################################################
command=''
if [[ $extension == 'tar' ]];then
	command='-zxvf'
elif [[ $extension == 'tar.gz' ]];then
	command='-zxvf'
elif [[ $extension == 'tar.bz2' ]];then
	command='-jxvf'
elif [[ $extension == 'tar.xz' ]];then
	command='-Jxvf'
fi
#######################################################################
# compile package
#######################################################################
echo -e $RED"Installation of $package ....... started"$RESET
cd $SOURCE_DIR
echo -e $RED"removing old installation of $package"$RESET
rm --recursive --force --verbose $package*
wget --content-disposition $SOURCE_DOWNLOAD_URL/$package/$package-$version.$extension
tar $command $package-$version.$extension
cd $package*
chmod +x ./configure

#	--extra-cflags=-I/usr/include \
#	--extra-cflags=-I/usr/include \
#	--extra-ldflags=-L/usr/lib \
#	--prefix=$PREFIX_DIR \
#	--bindir=/usr/bin \
#	--datadir=/usr/share/ffmpeg \
#	--incdir=/usr/include/ffmpeg \
#	--libdir=/usr/lib64 \
#	--mandir=/usr/share/man \
#--optflags='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic' \

./configure \
	--prefix=$PREFIX_DIR \
	--enable-static \
	--enable-shared \
	--extra-cflags=-I$INCLUDE_DIRECTORY \
	--extra-ldflags=-L$LIBRARY_DIRECTORY \
	--pkg-config=pkg-config \
	--enable-pthreads \
	--enable-gpl \
	--enable-version3 \
	--enable-nonfree \
	--disable-avisynth \
	--enable-fontconfig \
	--enable-frei0r \
	--enable-gnutls \
	--enable-ladspa \
	--disable-libaacplus \
	--enable-libass \
	--disable-libbluray \
	--disable-libbs2b \
	--disable-libcaca \
	--disable-libcelt \
	--disable-libcdio \
	--disable-libdc1394 \
	--disable-libfaac \
	--enable-libfdk-aac \
	--disable-libflite \
	--enable-libfreetype \
	--enable-libfribidi \
	--disable-libgme \
	--disable-libgsm \
	--disable-libiec61883 \
	--enable-libilbc \
	--enable-libmodplug \
	--enable-libmp3lame \
	--disable-libnut \
	--enable-libopencore-amrnb \
	--enable-libopencore-amrwb \
	--enable-libopencv \
	--enable-libopenjpeg \
	--enable-libopus \
	--disable-libpulse \
	--enable-libquvi \
	--disable-librtmp \
	--disable-libschroedinger \
	--disable-libshine \
	--disable-libsmbclient \
	--disable-libsoxr \
	--enable-libspeex \
	--disable-libssh \
	--disable-libstagefright-h264 \
	--enable-libtheora \
	--enable-libtwolame \
	--disable-libutvideo \
	--disable-libv4l2 \
	--disable-libvidstab \
	--enable-libvo-aacenc \
	--enable-libvo-amrwbenc \
	--enable-libvorbis \
	--enable-libvpx \
	--disable-libwavpack \
	--enable-libwebp \
	--enable-libx264 \
	--enable-libx265 \
	--disable-libxavs \
	--disable-libxcb \
	--disable-libxcb-shm \
	--disable-libxcb-xfixes \
	--disable-libxcb-shape \
	--enable-libxvid \
	--disable-libzmq \
	--disable-libzvbi \
	--disable-decklink \
	--disable-openal \
	--disable-opencl \
	--disable-opengl \
	--disable-openssl \
	--disable-x11grab \
	--enable-pic \
	--enable-thumb \
	--enable-lto \
	--enable-ffmpeg \
	--enable-ffplay \
	--enable-ffprobe \
	--enable-ffserver
make -j $PROCESSOR
make tools/qt-faststart
make install
cp -vf tools/qt-faststart $PREFIX_DIR/bin
ln -sf $PREFIX_DIR/bin/ffmpeg /usr/local/bin/ffmpeg
ln -sf $PREFIX_DIR/bin/ffmpeg /usr/bin/ffmpeg
ln -sf $PREFIX_DIR/bin/qt-faststart /usr/local/bin/qt-faststart
ln -sf $PREFIX_DIR/bin/qt-faststart /usr/bin/qt-faststart
ldconfig
echo -e $RED"Installation of $package ....... Completed"$RESET