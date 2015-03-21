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
SOURCE_DOWNLOAD_URL='https://www.ffmpeg.org/releases'
#######################################################################
# install
#######################################################################
PREFIX_DIR='/usr/local'
#######################################################################
# flags
#######################################################################
CPPFLAGS=-I$PREFIX_DIR/include
LDFLAGS=-L$PREFIX_DIR/lib
#######################################################################
# export
#######################################################################
export PROCESSOR=`cat "/proc/cpuinfo" | grep "processor"|wc -l`
export TMPDIR=$HOME/tmp
#######################################################################
# package
#######################################################################
package='ffmpeg'
version='2.5.4'
extension='tar.gz'
#######################################################################
# Detect platform
#######################################################################
PLATFORM=`uname`
#######################################################################
# Detect package type from /etc/issue
#######################################################################
_detect_arch() {
  local _osarch _osarch

  _osarch="$1"; shift

  grep -qis "$@" /etc/issue \
  && _OSARCH="$_osarch" && return

  grep -qis "$@" /etc/os-release \
  && _OSARCH="$_osarch" && return
}

_detect_distribution() {
  _detect_arch pacman "Arch Linux" && return
  _detect_arch dpkg "Debian GNU/Linux" && return
  _detect_arch dpkg "Ubuntu" && return
  _detect_arch cave "Exherbo Linux" && return
  _detect_arch yum "CentOS" && return
  _detect_arch yum "Red Hat" && return
  _detect_arch yum "Fedora" && return
  _detect_arch zypper "SUSE" && return

  [[ -z "$_OSARCH" ]] || return
  [[ -x "/usr/bin/apt-get" ]] && _OSARCH="dpkg" && return
  [[ -x "/usr/bin/cave" ]] && _OSARCH="cave" && return
  [[ -x "/usr/bin/yum" ]] && _OSARCH="yum" && return
  [[ -x "/opt/local/bin/port" ]] && _OSARCH="macports" && return
  [[ -x "/usr/bin/emerge" ]] && _OSARCH="portage" && return
  [[ -x "/usr/bin/zypper" ]] && _OSARCH="zypper" && return
  [[ -x "/usr/sbin/pkg" ]] && _OSARCH="pkgng" && return

  command -v brew >/dev/null && _OSARCH="homebrew" && return

  return 1
}
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
# detect distribution
#######################################################################
_detect_distribution
echo -e $RED"Installation of $package ....... started"$RESET
if [[ $_OSARCH == yum ]];then
	yum -y install openjpeg openjpeg-devel libass libass-devel opencv opencv-core opencv-devel fribidi fribidi-devel ladspa ladspa-devel
fi
#if [[ $_OSARCH == yum ]];then
#	yum -y install gnutls-devel ladspa-devel SDL-devel \
#	gsm-devel libiec61883-devel libmodplug-devel libquvi-devel librtmp-devel libssh-devel \
#	libv4l libvpx-devel libwebp-devel
#fi
cd $SOURCE_DIR
echo -e $RED"removing old installation of $package"$RESET
rm --recursive --force --verbose $package*
wget --content-disposition $SOURCE_DOWNLOAD_URL/$package-$version.$extension
tar $command $package-$version.$extension
cd $package-$version
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

./configure \
	--prefix=$PREFIX_DIR \
	--optflags='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong --param=ssp-buffer-size=4 -grecord-gcc-switches -m64 -mtune=generic' \
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
	--enable-librtmp \
	--disable-libschroedinger \
	--disable-libshine \
	--disable-libsmbclient \
	--disable-libsoxr \
	--enable-libspeex \
	--enable-libssh \
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
	--enable-openssl \
	--disable-x11grab \
	--enable-pic \
	--enable-thumb \
	--enable-lto \
	--disable-ffplay \
	--disable-ffprobe \
	--disable-ffserver
make -j $PROCESSOR
make tools/qt-faststart
make install
cp -vf tools/qt-faststart /usr/bin
ldconfig
echo -e $RED"Installation of $package ....... Completed"$RESET