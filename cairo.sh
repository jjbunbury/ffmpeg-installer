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
export pixman_CFLAGS=-I$INCLUDE_DIRECTORY/pixman-1
export pixman_LIBS="-L$LIBRARY_DIRECTORY -lpixman-1"
export GOBJECT_CFLAGS="-I$INCLUDE_DIRECTORY/glib-2.0 -I$LIBRARY_DIRECTORY/glib-2.0/include"
export GOBJECT_LIBS="-L$LIBRARY_DIRECTORY -lgobject-2.0"
export glib_CFLAGS="-I$INCLUDE_DIRECTORY/glib-2.0 -I$LIBRARY_DIRECTORY/glib-2.0/include"
export glib_LIBS="-L$LIBRARY_DIRECTORY -lglib-2.0"
#######################################################################
# package
#######################################################################
package='cairo'
version='1.14.2'
extension='tar.xz'
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
chmod +x ./configure && ./configure \
	--prefix=$PREFIX_DIR \
	--enable-static \
	--enable-shared \
	--enable-fast-install \
	--enable-xlib=auto \
	--enable-xlib-xrender=auto \
	--enable-xcb=auto \
	--enable-xlib-xcb=auto \
	--enable-xcb-shm=auto \
	--enable-qt=auto \
	--enable-quartz=auto \
	--enable-quartz-font=auto \
	--enable-quartz-image=auto \
	--enable-drm=auto \
	--enable-gallium=auto \
	--enable-png=auto \
	--enable-gl=auto \
	--enable-vg=auto \
	--enable-egl=auto \
	--enable-glx=auto \
	--enable-wgl=auto \
	--enable-script=auto \
	--enable-ft=auto \
	--enable-fc=auto \
	--enable-ps=auto \
	--enable-pdf=auto \
	--enable-svg=auto \
	--enable-tee=auto \
	--enable-xml=auto \
	--enable-pthread=auto \
	--enable-gobject=auto \
	--enable-trace=auto \
	--enable-interpreter=auto \
	--enable-symbol-lookup=auto
make -j $PROCESSOR
make install
ldconfig
echo -e $RED"Installation of $package ....... Completed"$RESET