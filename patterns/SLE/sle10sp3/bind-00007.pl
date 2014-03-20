#!/usr/bin/perl

# Title:       LTSS Bind SA SUSE-SU-2012:1333-1
# Description: Fixes one vulnerability
# Modified:    2013 Jun 26

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
	PROPERTY_NAME_CLASS."=Security",
	PROPERTY_NAME_CATEGORY."=SLE",
	PROPERTY_NAME_COMPONENT."=DNS",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_Security",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2012-10/msg00007.html"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $NAME = 'LTSS Bind';
	my $MAIN_PACKAGE = 'bind';
	my $SEVERITY = 'Critical';
	my $TAG = 'SUSE-SU-2012:1333-1';
	my %PACKAGES = ();
	if ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
		%PACKAGES = (
			'bind' => '9.3.4-1.40.1',
			'bind-chrootenv' => '9.3.4-1.40.1',
			'bind-devel' => '9.3.4-1.40.1',
			'bind-doc' => '9.3.4-1.40.1',
			'bind-libs-32bit' => '9.3.4-1.40.1',
			'bind-libs' => '9.3.4-1.40.1',
			'bind-utils' => '9.3.4-1.40.1',
		);
		SDP::SUSE::securityAnnouncementPackageCheck($NAME, $MAIN_PACKAGE, $SEVERITY, $TAG, \%PACKAGES);
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: $NAME Security Announcement: Outside the kernel scope");
	}
SDP::Core::printPatternResults();

exit;

