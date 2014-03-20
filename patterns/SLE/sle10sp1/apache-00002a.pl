#!/usr/bin/perl

# Title:       Apache Security Advisory SUSE-SA:2008:021
# Description: Apache was updated to fix cross site scripting security issues, Severity 6 of 10.
# Modified:    2013 Jun 26

# See TO DO below
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
	PROPERTY_NAME_COMPONENT."=Apache",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_Security",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_Security=http://www.novell.com/linux/security/advisories/2008_21_apache.html"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $CHECKING            = 'Apache';
	my $ADVISORY            = '6';
	my $TYPE                = 'Cross site scripting';
	my @PKGS_TO_CHECK       = ();
	my $FIXED_VERSION       = '';
	my $SUCCESS             = 0;

	if  ( SDP::SUSE::compareKernel(SLE9SP5) <= 0 ) {
		SDP::Core::setStatus(STATUS_SUCCESS, "Level $ADVISORY $CHECKING $TYPE vulnerability AVOIDED");
		SDP::Core::printDebug('DISTRIBUTION', 'SLE9');
		@PKGS_TO_CHECK       = qw(apache apache-devel apache-doc apache-example-pages);
		$FIXED_VERSION       = '1.3.29-71.26';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
		@PKGS_TO_CHECK       = qw(mod_ssl);
		$FIXED_VERSION       = '2.8.16-71.26';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
		@PKGS_TO_CHECK       = qw(apache2 apache2-devel apache2-doc apache2-example-pages apache2-prefork apache2-worker libapr0);
		$FIXED_VERSION       = '2.0.59-1.8';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
		if ( ! $SUCCESS ) {
			SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: No package(s) installed");
		}
	} elsif ( SDP::SUSE::compareKernel(SLE10SP1) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE10_SP1');
		@PKGS_TO_CHECK       = qw(apache2 apache2-devel apache2-doc apache2-example-pages apache2-prefork apache2-worker);
		$FIXED_VERSION       = '2.2.3-16.17.3';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} else {
		SDP::Core::printDebug('DISTRIBUTION', 'None Selected');
		SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: Outside the kernel scope");
	}

SDP::Core::printPatternResults();

exit;
