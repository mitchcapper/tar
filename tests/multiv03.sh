#! /bin/sh
# This file is part of GNU tar testsuite.
# Copyright (C) 2004 Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.

# Problem: GNU multivolume archives are not able to continue on members
# with filenames longer than 100 characters. Versions of tar <= 1.14
# were not checking filename lengths and produced malformed multivolume
# headers.
# References: <20040809214854.GB32706@suse.de>
# http://lists.gnu.org/archive/html/bug-tar/2004-08/msg00012.html

. ./preset
TAR_ARCHIVE_FORMATS="gnu oldgnu"
. $srcdir/before

AFILE=`awk 'BEGIN { for (i = 0; i < 100; i++) printf "a"; exit; }'`
BFILE=`awk 'BEGIN { for (i = 0; i < 101; i++) printf "b"; exit; }'`
genfile --length 15360 > $AFILE

tar -M -L 10 -c -f arch.1 -f arch.2 $AFILE
tar -tM -f arch.1 -f arch.2

echo separator

genfile --length 15360 > $BFILE
tar -M -L 10 -c -f arch.1 -f arch.2 $BFILE

out="\
$AFILE
separator
"

err="\
tar: $BFILE: file name too long to be stored in a GNU multivolume header
tar: Error is not recoverable: exiting now
"

. $srcdir/after