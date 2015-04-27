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
SOURCE_DIR=''
SOURCE_DOWNLOAD_URL=''
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
package=''
version=''
extension=''
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
# cpanel rebuild httpd
#######################################################################
if [ -e "/scripts/rebuildhttpdconf" ];then
	/scripts/rebuildhttpdconf
fi
echo " "
echo " "
echo "The ffmpeg and dependency package installation has been completed."
echo "paths for the major binary locations. Make sure to configure it in your conversion scripts too."
echo ""
which {ffmpeg,mplayer,mencoder,flvtool2,MP4Box,yamdi}
echo " "
echo "Don't forget to do the following"
echo " "
echo " "
echo "Edit your php.ini and increase the value of post_max_size if you need to post big files via php scripts"
echo "Edit your php.ini and increase the value of upload_max_filesize if you need to upload big video file"
echo "Restart web server(httpd/nginx,etc.)"
echo "Test the installation"
echo " "
echo " "