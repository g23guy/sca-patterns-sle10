#!/usr/bin/perl -w

# Title:       How to update to SLES/SLED 10 SP2
# Description: An SLE10 system running a version of SLES or SLED prior to Service Pack 2 should be updated to SLES10 Service Pack 2 or SLED10 Service Pack 2.
# Modified:    2013 Jun 25

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
#  along with this program; if not, see <http://www.gnu.org/licenses/>.
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
	PROPERTY_NAME_CATEGORY."=Update",
	PROPERTY_NAME_COMPONENT."=Procedure",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7000387"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my %HOSTINFO = SDP::SUSE::getHostInfo();

	if      ( SDP::SUSE::compareKernel('2.6.16') > 0 ) {
		SDP::Core::updateStatus(STATUS_ERROR, "Updating to SLE10 does not apply, Kernel: $HOSTINFO{'kernel'}");
	} elsif ( SDP::SUSE::compareKernel('2.6.16') < 0 ) {
		SDP::Core::updateStatus(STATUS_CRITICAL, "Seriously consider updating to the newest version of SUSE, Kernel: $HOSTINFO{'kernel'}");
	} elsif ( SDP::SUSE::compareKernel('2.6.16.60-0.21') < 0 ) {
		SDP::Core::updateStatus(STATUS_WARNING, "Updating the server to SLE10 SP2 is recommended, Kernel: $HOSTINFO{'kernel'}");
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "Server already updated to SLE10 SP2, Kernel: $HOSTINFO{'kernel'}");
	}
SDP::Core::printPatternResults();

exit;

