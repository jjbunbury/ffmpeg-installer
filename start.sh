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
SOURCE_DOWNLOAD_URL=''
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
package=''
version=''
extension=''
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
#######################################################################
# presetup
#######################################################################
sh presetup.sh
#######################################################################
# required RPM
#######################################################################
if [[ $_OSARCH == yum ]];then
	echo "Ensuring required RPM ........"
	yum install autoconf automake epel-release expat expat-devel fontconfig fontconfig-devel freetype freetype-devel \
	gcc gcc-c++ gd gd-devel gettext gettext-devel giflib giflib-devel ImageMagick ImageMagick-devel \
	libgcc libjpeg-turbo libjpeg-turbo-devel libpng libpng-devel libstdc++ libstdc++-devel libtiff libtiff-devel \
	libtool libxml libxml-devel libxml2 libxml2-devel make neon neon-devel patch samba-common zlib zlib-devel \
	bison bison-devel bzip2 bzip2-devel \
	openssl-devel subversion SDL-devel gnutls gnutls-devel -y
	export ARCH=$(arch)
fi

if [ -e "/etc/csf/csf.conf" ];then
	csf -x
fi

if [ -e "/etc/debianversion" ];then
	echo "Ensuring Debian packages ....."
	apt-get install gcc libgd-dev gettext libpng-dev libstdc++-dev \
		libtiff-dev libtool libxml2 libxml2-dev automake autoconf libncurses-dev ncurses-dev patch \
		make git subversion -y
fi

#######################################################################
# nasm
#######################################################################
# requires: CCACHE
# status: Validated
sh nasm.sh
if [ -e $PREFIX_DIR/bin/nasm ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"nasm installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# yasm
#######################################################################
# requires: libintl, libiconv, Cython (optional), python (optional), python-devel (optional)
# status: Validated
sh yasm.sh
if [ -e $PREFIX_DIR/bin/yasm ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"yasm installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# deprecated 
#######################################################################
#avisynth
#libaacplus
#libbluray
#libbs2b
#libcaca
#libcelt
#libcdio
#libdc1394
#libfaac
#libflite
#libgme
#libgsm
#libiec61883
#libnut
#libpulse
#libschroedinger
#libshine
#libsmbclient
#libsoxr
#libstagefright-h264
#libutvideo
#libv4l2
#libvidstab
#libwavpack
#libxavs
#libxcb
#libxcb-shm
#libxcb-xfixes
#libxcb-shape

#libzmq \
#libzvbi \
#decklink \
#openal \
#opencl \
#opengl \

#x11grab
#######################################################################
# uses package manager dependency
#######################################################################

#fontconfig
#gnutls
#ladspa
#libass
#libfribidi
#libopencv
#libopenjpeg

#######################################################################
# dependency 
#######################################################################

#######################################################################
# encoders
#######################################################################

#frei0r
#requires: OPENCV, GAVL, CAIRO
# status: Validated
sh frei0r.sh

#libfdk-aac
sh libfdk-aac.sh
#libilbc
sh libilbc.sh

#libmodplug
sh libmodplug.sh

#libmp3lame
# status: Validated
sh libmp3lame.sh
if [ -e $PREFIX_DIR/bin/lame ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"lame installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#libopencore-amr
sh libopencore-amr.sh

#libopus
sh libopus.sh
#libquvi
#requires: libquvi_scripts, glib, libcurl, libproxy, liblua

#librtmp
#libspeex
#libssh

#libogg
# status: Validated
sh libogg.sh
if [ -e $PREFIX_DIR/lib/libogg.so ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libogg installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#libflac
# OGG, LIBICONV, XMMS (optional)
# status: Validated
sh libflac.sh

#libvorbis
#requires: OGG
# status: Validated
sh libvorbis.sh
if [ -e $PREFIX_DIR/lib/libvorbis.so ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libvorbis installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#vorbistools
#requires: OGG, VORBIS, CURL, AO, KATE, FLAC, SPEEX
sh vorbistools.sh

#libtheora
#requires: OGG, VORBIS, PNG, CAIRO
sh libtheora.sh
if [ -e $PREFIX_DIR/lib/libtheora.so ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libtheora installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#libtwolame

#libvo-aacenc
sh vo-aacenc.sh

#libvo-amrwbenc
sh vo-amrwbenc.sh

#libvpx
#libwebp
#libx264
#sh libx264.sh
#libx265
#sh libx265.sh

#libxvid
#openssl

#######################################################################
# end
#######################################################################

#######################################################################
# ffmpeg
#######################################################################
sh ffmpeg.sh
if [ -e $PREFIX_DIR/bin/ffmpeg ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"ffmpeg installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# Mp4Box
#######################################################################
#sh mp4box.sh

#######################################################################
# post
#######################################################################
#sh post.sh