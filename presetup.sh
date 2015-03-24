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
CPPFLAGS=-I$PREFIX_DIR/include
LDFLAGS=-L$PREFIX_DIR/lib
#######################################################################
# export
#######################################################################
export PROCESSOR=`cat "/proc/cpuinfo" | grep "processor" | wc -l`
export TMPDIR=$HOME/tmp
export PKG_CONFIG_PATH=$PREFIX_DIR/lib/pkgconfig
export LDFLAGS=$LDFLAGS
export CPPFLAGS=$CPPFLAGS
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
echo -n "Removing useless libraries, please wait............."
rm --recursive --force --verbose /lib/liba52*
rm --recursive --force --verbose /lib/libamr*
rm --recursive --force --verbose /lib/libavcodec*
rm --recursive --force --verbose /lib/libavformat*
rm --recursive --force --verbose /lib/libavutil*
rm --recursive --force --verbose /lib/libdha*
rm --recursive --force --verbose /lib/libfaac*
rm --recursive --force --verbose /lib/libfaad*
rm --recursive --force --verbose /lib/libmp3lame*
rm --recursive --force --verbose /lib/libmp4v2*
rm --recursive --force --verbose /lib/libogg*
rm --recursive --force --verbose /lib/libtheora*
rm --recursive --force --verbose /lib/libvorbis*

rm --recursive --force --verbose /usr/lib/liba52*
rm --recursive --force --verbose /usr/lib/libamr*
rm --recursive --force --verbose /usr/lib/libavcodec*
rm --recursive --force --verbose /usr/lib/libavformat*
rm --recursive --force --verbose /usr/lib/libavutil*
rm --recursive --force --verbose /usr/lib/libdha*
rm --recursive --force --verbose /usr/lib/libfaac*
rm --recursive --force --verbose /usr/lib/libfaad*
rm --recursive --force --verbose /usr/lib/libmp3lame*
rm --recursive --force --verbose /usr/lib/libmp4v2*
rm --recursive --force --verbose /usr/lib/libogg*
rm --recursive --force --verbose /usr/lib/libtheora*
rm --recursive --force --verbose /usr/lib/libvorbis*

rm --recursive --force --verbose /usr/local/lib/liba52*
rm --recursive --force --verbose /usr/local/lib/libamr*
rm --recursive --force --verbose /usr/local/lib/libavcodec*
rm --recursive --force --verbose /usr/local/lib/libavformat*
rm --recursive --force --verbose /usr/local/lib/libavutil*
rm --recursive --force --verbose /usr/local/lib/libdha*
rm --recursive --force --verbose /usr/local/lib/libfaac*
rm --recursive --force --verbose /usr/local/lib/libfaad*
rm --recursive --force --verbose /usr/local/lib/libmp3lame*
rm --recursive --force --verbose /usr/local/lib/libmp4v2*
rm --recursive --force --verbose /usr/local/lib/libogg*
rm --recursive --force --verbose /usr/local/lib/libtheora*
rm --recursive --force --verbose /usr/local/lib/libvorbis*

unlink  /usr/bin/ffmpeg >/dev/null 2>&1
unlink /usr/local/bin/ffmpeg >/dev/null 2>&1
unlink /bin/mplayer >/dev/null 2>&1
unlink /usr/bin/mplayer >/dev/null 2>&1
unlink  /usr/local/bin/mplayer >/dev/null 2>&1
unlink /bin/mencoder >/dev/null 2>&1
unlink /usr/bin/mencoder  >/dev/null 2>&1
unlink  /usr/local/bin/mencoder >/dev/null 2>&1
rm --recursive --force --verbose $HOME/tmp
mkdir --parents --verbose $HOME/tmp
echo -n ".......... done"
echo " "
echo "creating folders..........done"