#!/usr/bin/perl -w

# Title:       BNX2 Network Driver Package Loss
# Description: The BNX2 kernel module that shipped with the SLES10 has a been observed with a high ratio of dropped packets.
# Modified:    2013 Jun 24

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
#
#  Authors/Contributors:
#     Jason Record (jrecord@suse.com)
#
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
	PROPERTY_NAME_CATEGORY."=Network",
	PROPERTY_NAME_COMPONENT."=Driver",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7002506",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=417938"
);

use constant SLES10SP1 => '2.6.16.46-0.12';

##############################################################################
# Program execution functions
##############################################################################

sub packetsDropped {
	printDebug('>', 'packetsDropped');
	my $RCODE        = 0;
	my $FILE_OPEN    = 'network.txt';
	my $SECTION      = 'ifconfig -a';
	my @CONTENT      = ();
	my $LINE         = 0;

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			$LINE++;
			if ( /dropped\:(\d+)/i ) {
				printDebug("LINE $LINE", $_);
				$RCODE++ if ( $1 > 0 );
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	printDebug("< Return: $RCODE", 'packetsDropped');
	return $RCODE;
}

SDP::Core::processOptions();
	my %DRIVER_INFO = SDP::SUSE::getDriverInfo('bnx2');

	if ( $DRIVER_INFO{'loaded'} ) {
		if ( SDP::SUSE::compareKernel(SLES10SP1) >= 0 && SDP::SUSE::compareDriver('bnx2', '1.6.7c') <= 0 ) {
			if ( packetsDropped() ) {
				SDP::Core::updateStatus(STATUS_CRITICAL, "Packet loss with bnx2 driver detected");
			} else {
				SDP::Core::updateStatus(STATUS_WARNING, "Potential packet loss with bnx2 driver detected");
			}
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "Outside kernel scope, skipping bnx2 driver issue");
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "BNX2 Driver not in use");
	}
SDP::Core::printPatternResults();

exit;

