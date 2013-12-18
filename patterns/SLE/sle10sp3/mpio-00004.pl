#!/usr/bin/perl

# Title:       DM multipath kernel driver version too old
# Description: After updating, multipath commands fail
# Modified:    2013 Jun 27

##############################################################################
#  Copyright (C) 2013 SUSE LLC
##############################################################################
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; version 2 of the License.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

#  Authors/Contributors:
#   Jason Record (jrecord@suse.com)

##############################################################################

##############################################################################
# Module Definition
##############################################################################

use strict;
use warnings;
use SDP::Core;
use SDP::SUSE;

##############################################################################
# Overriden (eventually or in part) from SDP::Core Module
##############################################################################

@PATTERN_RESULTS = (
	PROPERTY_NAME_CLASS."=SLE",
	PROPERTY_NAME_CATEGORY."=Disk",
	PROPERTY_NAME_COMPONENT."=MPIO",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7008914",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=703013"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub oldKernelError {
	SDP::Core::printDebug('> oldKernelError', 'BEGIN');
	my $RCODE = 0;
	my $FILE_OPEN = 'mpio.txt';
	my $SECTION = 'multipath -ll';
	my @CONTENT = ();

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( m/^\s*$/ ); # Skip blank lines
			if ( /DM multipath kernel driver version too old/i ) {
				$RCODE++;
				last;
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: oldKernelError(): Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	SDP::Core::printDebug("< oldKernelError", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $KERN_MPIO_VER = '2.6.16.60-0.79.1'; # SLES10 SP3
	my $KERN_MPIO_FIX = '2.6.16.60-0.81.2';
	if ( SDP::SUSE::compareKernel($KERN_MPIO_VER) >= 0 && SDP::SUSE::compareKernel($KERN_MPIO_FIX) < 0 ) {
		my $DRIVER_NAME = 'dm_multipath';
		my %DRIVER_INFO = SDP::SUSE::getDriverInfo($DRIVER_NAME);
		if ( $DRIVER_INFO{'loaded'} ) {
			if ( oldKernelError() ) {
				SDP::Core::updateStatus(STATUS_CRITICAL, "Kernel conflict, multipath commands are failing");
			} else {
				SDP::Core::updateStatus(STATUS_WARNING, "Kernel conflict, multipath commands may fail");
			}
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "Driver $DRIVER_NAME is NOT loaded, skipping MPIO test");
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Outside kernel scope, skipping MPIO test");
	}
SDP::Core::printPatternResults();

exit;

