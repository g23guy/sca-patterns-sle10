#!/usr/bin/perl

# Title:       Network connectivity lost after upgrade
# Description: After upgrading to specific kernels, the NIC card may sporadically lose network connectivity before regaining it.
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
	PROPERTY_NAME_CATEGORY."=Network",
	PROPERTY_NAME_COMPONENT."=Connectivity",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7005729",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=596193"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub broadcomBCM {
	SDP::Core::printDebug('> broadcomBCM', 'BEGIN');
	my $RCODE = 0;
	my $FILE_OPEN = 'hardware.txt';
	my $SECTION = 'lspci -b';
	my @CONTENT = ();

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( /^\s*$/ ); # Skip blank lines
			if ( /Ethernet controller.*Broadcom.*BCM/i ) {
				SDP::Core::printDebug("PROCESSING", $_);
				$RCODE++;
				last;
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: broadcomBCM(): Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	SDP::Core::printDebug("< broadcomBCM", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
		# check if only with smp kernel
		if ( SDP::SUSE::compareKernel('2.6.16.60-0.59.1') == 0 || SDP::SUSE::compareKernel('2.6.16.60-0.60.1') == 0 ) { 
			my $DRIVER_NAME = 'tg3';
			my %DRIVER_INFO = SDP::SUSE::getDriverInfo($DRIVER_NAME);
			if ( $DRIVER_INFO{'loaded'} ) {
				if ( broadcomBCM() ) {
					SDP::Core::updateStatus(STATUS_CRITICAL, "Network connectivity may be intermittent due to kernel version");
				} else {
					SDP::Core::updateStatus(STATUS_ERROR, "Network connectivity kernel issue with Broadcom NIC cards not observed");
				}
			} else {
				SDP::Core::updateStatus(STATUS_ERROR, "Skipping network test, $DRIVER_NAME driver NOT loaded");
			}
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "Network connectivity kernel issue not observed");
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Skipping network test, outside kernel scope");
	}
SDP::Core::printPatternResults();

exit;


