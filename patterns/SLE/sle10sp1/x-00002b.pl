#!/usr/bin/perl

# Title:       X Windows Security Advisory SUSE-SA:2008:027
# Description: XFree86/xorg-x11 updated to fix local code execution security issues, Severity 6 of 10.
# Modified:    2013 Jun 27

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
	PROPERTY_NAME_COMPONENT."=X",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_Security",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_Security=http://www.novell.com/linux/security/advisories/2008_27_xorg.html"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $CHECKING            = 'X Windows';
	my $ADVISORY            = '6';
	my $TYPE                = 'Local code execution';
	my @PKGS_TO_CHECK       = ();
	my $FIXED_VERSION       = '';

	if  ( SDP::SUSE::compareKernel(SLE9SP5) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE9');
		@PKGS_TO_CHECK       = qw(XFree86-server XFree86-Xnest XFree86-Xprt XFree86-Xvfb XFree86-Xvnc);
		$FIXED_VERSION       = '4.3.99.902-43.96';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} elsif ( SDP::SUSE::compareKernel(SLE10SP1) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE10_SP1');
		@PKGS_TO_CHECK       = qw(xorg-x11-server xorg-x11-Xnest xorg-x11-Xvfb xorg-x11-Xvnc);
		$FIXED_VERSION       = '6.9.0-50.54.11';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} elsif ( SDP::SUSE::compareKernel(SLE10SP2) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE10_SP2');
		@PKGS_TO_CHECK       = qw(xorg-x11-server xorg-x11-Xnest xorg-x11-Xvfb xorg-x11-Xvnc);
		$FIXED_VERSION       = '6.9.0-50.60';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} else {
		SDP::Core::printDebug('DISTRIBUTION', 'None Selected');
		SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: Outside the kernel scope");
	}

SDP::Core::printPatternResults();

exit;
