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
export PATH="$PREFIX_DIR/bin:$PATH"
export CPATH="$PREFIX_DIR/include:$CPATH"
export LD_LIBRARY_PATH="$PREFIX_DIR/lib:$LD_LIBRARY_PATH"
export LIBRARY_PATH="$PREFIX_DIR/lib:$LIBRARY_PATH"
#######################################################################
# export
#######################################################################
export PROCESSOR=`cat "/proc/cpuinfo" | grep "processor" | wc -l`
export TMPDIR="$HOME/tmp"
export PKG_CONFIG_PATH="$PREFIX_DIR/lib/pkgconfig"
export LDFLAGS="-L$PREFIX_DIR/lib"
export CFLAGS="-I$PREFIX_DIR/include"
export CPPFLAGS="-I$PREFIX_DIR/include"
#######################################################################
# miscellaneous export
#######################################################################
export OGG_CFLAGS=-I$PREFIX_DIR/include
export OGG_LIBS="-L$PREFIX_DIR/lib -logg"
export VORBIS_CFLAGS=-I$PREFIX_DIR/include
export VORBIS_LIBS="-L$PREFIX_DIR/lib -lvorbis"
#export CURL_CFLAGS=-I$PREFIX_DIR/include
#export CURL_LIBS="-L$PREFIX_DIR/lib -lcurl"
export AO_CFLAGS=-I$PREFIX_DIR/include
export AO_LIBS="-L$PREFIX_DIR/lib -lao"
export KATE_CFLAGS=-I$PREFIX_DIR/include
export KATE_LIBS="-L$PREFIX_DIR/lib -lkate"
#######################################################################
# package
#######################################################################
package='vorbis-tools'
version='1.4.0'
extension='tar.gz'
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

#  --with-libpth-prefix$PREFIX_DIR \
#  --with-libiconv-prefix=$PREFIX_DIR \
#  --with-included-gettext=$PREFIX_DIR/include \
#  --with-libintl-prefix=$PREFIX_DIR \

#	--with-curl=$PREFIX_DIR \
#	--with-curl-libraries=$PREFIX_DIR/lib \
#	--with-curl-includes=$PREFIX_DIR/include \

chmod +x ./configure && ./configure \
	--prefix=$PREFIX_DIR \
	--enable-static \
	--enable-shared \
	--enable-fast-install \
	--with-ogg=$PREFIX_DIR \
	--with-ogg-libraries=$PREFIX_DIR/lib \
	--with-ogg-includes=$PREFIX_DIR/include \
	--with-vorbis=$PREFIX_DIR \
	--with-vorbis-libraries=$PREFIX_DIR/lib \
	--with-vorbis-includes=$PREFIX_DIR/include
make -j $PROCESSOR
make install
ldconfig
echo -e $RED"Installation of $package ....... Completed"$RESET