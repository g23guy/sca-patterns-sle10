#!/usr/bin/perl

# Title:       Inncorect Date Command Results
# Description: Date command does not show correct results due to DST
# Modified:    2013 Jun 27

##############################################################################
#  Copyright (C) 2013,2013 SUSE LLC
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

#  Authors/Contributors:
#   Jason Record (jrecord@suse.com)

##############################################################################
# The META_LINK_TID=http://www.novell.com/support/kb/doc.php?id=7004936 has been deleted.

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
	PROPERTY_NAME_CATEGORY."=System",
	PROPERTY_NAME_COMPONENT."=Date",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=557051"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( SDP::SUSE::compareKernel(SLE10GA) > 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
		my $RPM_NAME = 'coreutils';
		my $VERSION_TO_COMPARE = '5.93-22.18.23.1';
		my $RPM_COMPARISON = SDP::SUSE::compareRpm($RPM_NAME, $VERSION_TO_COMPARE);
		if ( $RPM_COMPARISON == 2 ) {
			SDP::Core::updateStatus(STATUS_ERROR, "ERROR: RPM $RPM_NAME Not Installed");
		} elsif ( $RPM_COMPARISON > 2 ) {
			SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Multiple Versions of $RPM_NAME RPM are Installed");
		} else {
			if ( $RPM_COMPARISON < 0 ) {
				SDP::Core::updateStatus(STATUS_WARNING, "Date command results invalid due to DST, update system to applay $RPM_NAME-$VERSION_TO_COMPARE or higher.");
			} else {
				SDP::Core::updateStatus(STATUS_ERROR, "Date command results not affected by DST");
			}			
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: Date command check: Outside the kernel scope");
	}
SDP::Core::printPatternResults();

exit;


