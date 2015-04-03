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
PREFIX_DIR='/usr/local/encoder'
#######################################################################
# flags
#######################################################################
EXTRA_CFLAGS=-I$PREFIX_DIR/include
EXTRA_LDFLAGS=-L$PREFIX_DIR/lib
#######################################################################
# export
#######################################################################
export PROCESSOR=`cat "/proc/cpuinfo" | grep "processor" | wc -l`
export TMPDIR=$HOME/tmp
export PKG_CONFIG_PATH=$PREFIX_DIR/lib/pkgconfig
export LDFLAGS=$EXTRA_LDFLAGS
export CPPFLAGS=$EXTRA_CFLAGS
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
	libtool libxml libxml-devel libxml2 libxml2-devel make neon neon-devel patch python python-devel samba-common zlib zlib-devel \
	
	bison bison-devel bzip2 bzip2-devel \
	openssl openssl-devel SDL SDL-devel gnutls gnutls-devel -y
	export ARCH=$(arch)
fi

if [ -e "/etc/csf/csf.conf" ];then
	csf -x
fi

if [ -e "/etc/debianversion" ];then
	echo "Ensuring Debian packages ....."
	apt-get install gcc libgd-dev gettext libpng-dev libstdc++-dev \
		libtiff-dev libtool libxml2 libxml2-dev automake autoconf libncurses-dev ncurses-dev patch \
		make -y
fi

#######################################################################
# nasm
# Status: Completed
# Required: ccache
# Optional: nroff, asciidoc, xmlto, acrodist, ps2pdf, pstopdf
#######################################################################
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
# Status: Completed
# Required: libiconv, python
# Optional: binutils, xmlto
#######################################################################
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
# sqlite
# Status: Completed
# Required: readline, ncurses
# Optional: None
#######################################################################
sh sqlite.sh
if [ -e $PREFIX_DIR/bin/sqlite3 ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"sqlite installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# git
# Status: Completed
# Required: None
# Optional: None
#######################################################################
sh git.sh
if [ -e $PREFIX_DIR/bin/git ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"git installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# subversion
# Status: Completed
# Required: None
# Optional: None
#######################################################################
sh subversion.sh
if [ -e $PREFIX_DIR/bin/svn ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"subversion installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# encoders
#######################################################################

#######################################################################
# frei0r
# Status: Completed
# Required: opencv, gavl, cairo
# Optional: doxygen
#######################################################################
sh frei0r.sh
if [ -d $PREFIX_DIR/lib/frei0r-1 ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"frei0r installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libfdk-aac
# Status: Completed
# Required: none
# Optional: none
#######################################################################
sh libfdk-aac.sh
if [ -e $PREFIX_DIR/lib/libfdk-aac.so ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"frei0r installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libilbc
# Status: Completed
# Required: none
# Optional: none
#######################################################################
sh libilbc.sh
if [ -e $PREFIX_DIR/lib/libilbc.so ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libilbc installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libmodplug
# Status: Completed
# Required: none
# Optional: none
#######################################################################
sh libmodplug.sh
if [ -e $PREFIX_DIR/lib/libmodplug.so ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libmodplug installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libogg
# Status: Completed
# Required: none
# Optional: none
#######################################################################
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

#######################################################################
# libflac
# Status: Completed
# Required: xmms, ogg, libiconv
# Optional: clang
#######################################################################
sh libflac.sh
if [ -e $PREFIX_DIR/lib/libFLAC.so ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libflac installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libvorbis
# Status: Completed
# Required: ogg
# Optional: none
#######################################################################
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

#######################################################################
# speexdsp
# Status: Completed
# Required: neon
# Optional: FFT
#######################################################################
sh speexdsp.sh
if [ -e $PREFIX_DIR/lib/libspeexdsp.so ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libspeexdsp installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libspeex
# Status: Completed
# Required: OGG, FFT, SPEEXDSP
# Optional: none
#######################################################################
sh libspeex.sh
if [ -e $PREFIX_DIR/lib/libspeex.so ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libspeex installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# liboggz
# Status: Completed
# Required: ogg
# Optional: doxygen, man2html
#######################################################################
sh liboggz.sh
if [ -e $PREFIX_DIR/lib/liboggz.so ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"liboggz installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libkate
# Status: Completed
# Required: ogg, png, oggz, python
# Optional: doxygen, bison, byacc, binutils
#######################################################################
sh libkate.sh
if [[ -e $PREFIX_DIR/lib/libkate.so || -e $PREFIX_DIR/lib/libkate.a ]]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libkate installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libao
# Status: Completed
# Required: alsa
# Optional: esound, alsa, arts, nas, pulse, wmm
#######################################################################
sh libao.sh
if [[ -e $PREFIX_DIR/lib/libao.so || -e $PREFIX_DIR/lib/libao.a ]]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libao installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# vorbis-tools
# Status: Completed
# Required: OGG, VORBIS, CURL, AO, flac, speex, kate
# Optional: libpth, libiconv, gettext, libintl
#######################################################################
sh vorbistools.sh
if [ -e $PREFIX_DIR/bin/vorbiscomment ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"vorbis-tools installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libtheora
# Status: Completed
# Required: ogg, vorbis, png, cairo
# Optional: sdl
#######################################################################
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

#######################################################################
# libsndfile
# Status: Completed
# Required: flac, ogg, speex, vorbis, sqlite
# Optional: none
#######################################################################
sh libsndfile.sh
if [ -e $PREFIX_DIR/lib/libsndfile.so ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libsndfile installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libmp3lame
# Status: Completed
# Required: sndfile, libiconv
# Optional: gtk, ncurses
#######################################################################
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

#######################################################################
# libopencore-amr
# Status: Completed
# Required: none
# Optional: none
#######################################################################
sh libopencore-amr.sh
if [[ -e $PREFIX_DIR/lib/libopencore-amrnb.so && -e $PREFIX_DIR/lib/libopencore-amrwb.so ]]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libopencore-amr installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libopus
# Status: Completed
# Required: gawk
# Optional: none
#######################################################################
sh libopus.sh
if [[ -e $PREFIX_DIR/lib/libopus.so || -e $PREFIX_DIR/lib/libopus.a ]]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libopus installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libquvi-scripts
# Status: libquvi-scripts
# Required: gawk, quvi, prove
# Optional: valgrind
#######################################################################
sh libquvi-scripts.sh
if [ -d $PREFIX_DIR/share/libquvi-scripts ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libquvi-scripts installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libquvi
# Status: libquvi
# Required: liblua, libcurl, libquvi_scripts
# Optional: libsoup_gnome, libsoup
#######################################################################
sh libquvi.sh
if [[ -e $PREFIX_DIR/lib/libquvi.so || -e $PREFIX_DIR/lib/libquvi.a ]]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libquvi installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# quvi
# Status: Completed
# Required: libquvi, libcurl
# Optional: none
#######################################################################
sh quvi.sh
if [ -e $PREFIX_DIR/bin/quvi ]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"quvi installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#librtmp

#######################################################################
# libtwolame
# Status: Completed
# Required: sndfile, gawk
# Optional: none
#######################################################################
sh libtwolame.sh
if [[ -e $PREFIX_DIR/lib/libtwolame.so || -e $PREFIX_DIR/lib/libtwolame.a ]]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libtwolame installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libvo-aacenc
# Status: Completed
# Required: gawk
# Optional: none
#######################################################################
sh vo-aacenc.sh
if [[ -e $PREFIX_DIR/lib/libvo-aacenc.so || -e $PREFIX_DIR/lib/libvo-aacenc.a ]]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libvo-aacenc installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libvo-amrwbenc
# Status: Completed
# Required: gawk
# Optional: none
#######################################################################
sh vo-amrwbenc.sh
if [[ -e $PREFIX_DIR/lib/libvo-amrwbenc.so || -e $PREFIX_DIR/lib/libvo-amrwbenc.a ]]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libvo-amrwbenc installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libvpx
# Status: Completed
# Required: ccache, yasm, nasm
# Optional: none
#######################################################################
sh libvpx.sh
if [[ -e $PREFIX_DIR/lib/libvpx.so || -e $PREFIX_DIR/lib/libvpx.a ]]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libvpx installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libwebp
# Status: Completed
# Required: png, jpeg, tiff, gif
# Optional: gl
#######################################################################
sh libwebp.sh
if [[ -e $PREFIX_DIR/lib/libwebp.so || -e $PREFIX_DIR/lib/libwebp.a ]]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libwebp installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libx264
# Status: Completed
# Required: opencl, avisynth, swscale, libavformat, ffms, gpac(mp4box) lsmash
# Optional: none
#######################################################################
sh libx264.sh
if [[ -e $PREFIX_DIR/lib/libx264.so || -e $PREFIX_DIR/lib/libx264.a ]]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libx264 installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libx264
# Status: Completed
# Required: yasm, libnuma
# Optional: none
#######################################################################
sh libx265.sh
if [[ -e $PREFIX_DIR/lib/libx265.so || -e $PREFIX_DIR/lib/libx265.a ]]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libx265 installation failed"$RESET
        echo " "
        echo " "
        exit
fi

#######################################################################
# libxvid
# Status: Completed
# Required: yasm
# Optional: none
#######################################################################
sh libxvid.sh
if [[ -e $PREFIX_DIR/lib/libxvidcore.so || -e $PREFIX_DIR/lib/libxvidcore.a ]]; then
        echo " "
else
        echo " "
        echo " "
        echo -e $RED"libxvidcore installation failed"$RESET
        echo " "
        echo " "
        exit
fi

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
sh post.sh