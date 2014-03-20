#!/usr/bin/perl

# Title:       Updates catalogs missing after updating libzypp patch
# Description: Channels or updates do not show up via rug or zen-updater after updating the server
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
	PROPERTY_NAME_CATEGORY."=Update",
	PROPERTY_NAME_COMPONENT."=Catalog",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7000452"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $CHECK_RPM='zmd';
	my $CHECK_RPMV='7.2.1.0-0.2.6';

	my $RPM_COMPARED = SDP::SUSE::compareRpm($CHECK_RPM, $CHECK_RPMV);
	if ( $RPM_COMPARED == 2 ) {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: RPM $CHECK_RPM Not Installed");
	} elsif ( $RPM_COMPARED > 2 ) {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Multiple $CHECK_RPM Versions Installed");
	} else {
		if ( $RPM_COMPARED < 0 ) {
			SDP::Core::updateStatus(STATUS_WARNING, "At risk for missing channels or updates via rug or zen-updater, Fix Needed: $CHECK_RPM-$CHECK_RPMV");
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "No missing catalogs due to patching observed");
		}
	}
SDP::Core::printPatternResults();

exit;


