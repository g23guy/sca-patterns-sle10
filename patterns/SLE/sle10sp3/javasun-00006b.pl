#!/usr/bin/perl

# Title:       Sun Java 1.6 Security Advisory SUSE-SA:2011:010
# Description: Sun Java 1.6 was updated to fix remote code execution security issues, CVSS v2.0 Base Score: 10.0
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
	PROPERTY_NAME_COMPONENT."=Java",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_Security",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_Security=http://www.novell.com/linux/security/advisories/2011_10_sunjava.html"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $CHECKING = 'Sun Java 1.6';
	my $SEVERITY = '10.0';
	my $TYPE = 'Remote code execution';
	my @PKGS_TO_CHECK = ();
	my $FIXED_VERSION = '';

	if ( SDP::SUSE::compareKernel(SLE11SP1) >= 0 && SDP::SUSE::compareKernel(SLE11SP2) < 0 ) {
		@PKGS_TO_CHECK = qw(java-1_6_0-sun java-1_6_0-sun-alsa java-1_6_0-sun-demo java-1_6_0-sun-jdbc java-1_6_0-sun-plugin java-1_6_0-sun-src);
		$FIXED_VERSION = '1.6.0.u24-0.2.1';
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $SEVERITY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} elsif ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
		@PKGS_TO_CHECK = qw(java-1_6_0-sun java-1_6_0-sun-alsa java-1_6_0-sun-demo java-1_6_0-sun-devel java-1_6_0-sun-jdbc java-1_6_0-sun-plugin java-1_6_0-sun-src);
		$FIXED_VERSION = '1.6.0.u24-0.5.1';
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $SEVERITY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: Outside the kernel scope");
	}

SDP::Core::printPatternResults();

exit;
