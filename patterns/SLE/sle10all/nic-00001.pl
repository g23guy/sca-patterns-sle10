#!/usr/bin/perl

# Title:       Network Problems with nVidia MCP55 network Devices
# Description: Sun Fire network cards reporting errors or failing at boot
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
use constant NIC_A => 0x0373;
use constant NIC_B => 0x0057;

##############################################################################
# Overriden (eventually or in part) from SDP::Core Module
##############################################################################

@PATTERN_RESULTS = (
	PROPERTY_NAME_CLASS."=SLE",
	PROPERTY_NAME_CATEGORY."=Network",
	PROPERTY_NAME_COMPONENT."=NIC",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7006203",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=570823"
);

my %AFFECTED_NICS = ();

##############################################################################
# Local Function Definitions
##############################################################################

sub nicsAffected {
	SDP::Core::printDebug('> nicsAffected', 'BEGIN');
	my $RCODE = 0;
	my $FILE_OPEN = 'network.txt';
	my $SECTION = 'hwinfo --netcard';
	my @CONTENT = ();

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( m/^\s*$/ ); # Skip blank lines
			if ( /Device:\s+pci\s+0x0373/i ) {
				SDP::Core::printDebug("PROCESSING", $_);
				$AFFECTED_NICS{NIC_A} = 1;
			} elsif ( /Device:\s+pci\s+0x0057/i ) {
				SDP::Core::printDebug("PROCESSING", $_);
				$AFFECTED_NICS{NIC_B} = 1;
			}
		}
		if ( scalar keys %AFFECTED_NICS > 0 ) {
			$RCODE = 1;
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: nicsAffected(): Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	SDP::Core::printDebug("< nicsAffected", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel('2.6.16.60-0.66.1') < 0) {
		if ( nicsAffected() ) {
			SDP::Core::updateStatus(STATUS_CRITICAL, "nVidia Ethernet card issue detected");
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "No nVidia Ethernet cards, skipping test");
		}
	} elsif ( SDP::SUSE::compareKernel('2.6.16.60-0.66.1') == 0) {
		nicsAffected();
		if ( $AFFECTED_NICS{NIC_A} ) {
			SDP::Core::updateStatus(STATUS_ERROR, "nVidia NIC PCI-ID 0x0373 driver updated");
		}
		if ( $AFFECTED_NICS{NIC_B} ) {
			SDP::Core::updateStatus(STATUS_CRITICAL, "nVidia NIC PCI-ID 0x0057 driver update needed");
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Outside kernel scope, skipping nVidea NIC test");
	}
SDP::Core::printPatternResults();

exit;

