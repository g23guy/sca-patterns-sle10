#!/usr/bin/perl

# Title:       IBM Java 1.4 Security Advisory SUSE-SA:2009:018
# Description: IBM Java 1.4 was updated to fix remote code execution security issues, Severity 7 of 10.
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
	PROPERTY_NAME_CLASS."=Security",
	PROPERTY_NAME_CATEGORY."=SLE",
	PROPERTY_NAME_COMPONENT."=Java",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_Security",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_Security=http://www.novell.com/linux/security/advisories/2009_18_ibmjava.html"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $CHECKING            = 'IBM Java 1.4';
	my $ADVISORY            = '7';
	my $TYPE                = 'Remote code execution';
	my @PKGS_TO_CHECK       = ();
	my $FIXED_VERSION       = '';
	my $SUCCESS             = 0;

	if  ( SDP::SUSE::compareKernel(SLE9SP5) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE9_ALL');
		my %HOSTINFO         = SDP::SUSE::getHostInfo();
		SDP::Core::printDebug('ARCH', $HOSTINFO{'architecture'});
		@PKGS_TO_CHECK       = qw(IBMJava2-JRE IBMJava2-SDK);
		if ( $HOSTINFO{'architecture'} =~ m/i??6/ ) {
			$FIXED_VERSION       = '1.4.2-0.133';
		} else {
			$FIXED_VERSION       = '1.4.2-0.139';
		}
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} elsif ( SDP::SUSE::compareKernel(SLE10SP2) >= 0 && SDP::SUSE::compareKernel(SLE11GA) < 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE10_SP2');
		@PKGS_TO_CHECK       = qw(java-1_4_2-ibm java-1_4_2-ibm-devel java-1_4_2-ibm-jdbc java-1_4_2-ibm-plugin);
		$FIXED_VERSION       = '1.4.2_sr13-0.4';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} elsif ( SDP::SUSE::compareKernel(SLE11GA) >= 0 && SDP::SUSE::compareKernel(SLE11SP1) < 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE11_SHIP');
		@PKGS_TO_CHECK       = qw(java-1_4_2-ibm java-1_4_2-ibm-devel java-1_4_2-ibm-jdbc java-1_4_2-ibm-plugin);
		$FIXED_VERSION       = '1.4.2_sr13-0.1.1';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} else {
		SDP::Core::printDebug('DISTRIBUTION', 'None Selected');
		SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: Outside the kernel scope");
	}

SDP::Core::printPatternResults();

exit;
