#!/usr/bin/perl

# Title:       Samba Security Advisory SUSE-SA:2008:026
# Description: samba was updated to fix remote code execution security issues, Severity 7 of 10.
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
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
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
	PROPERTY_NAME_COMPONENT."=Samba",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_Security",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_Security=http://www.novell.com/linux/security/advisories/2008_26_samba.html"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $CHECKING            = 'Samba';
	my $ADVISORY            = '7';
	my $TYPE                = 'Remote code execution';
	my @PKGS_TO_CHECK       = ();
	my $FIXED_VERSION       = '';

	if ( SDP::SUSE::compareKernel(SLE9SP5) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE9');
		# Files excluded from the pattern, but included in the advisory:
		# samba-vscan-0.3.6b-0.37.i586.rpm        307.3 KB (314683)
		@PKGS_TO_CHECK       = qw(samba libsmbclient libsmbclient-devel samba-client samba-doc samba-pdb samba-python samba-winbind);
		$FIXED_VERSION       = '3.0.26a-0.9';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} elsif ( SDP::SUSE::compareKernel(SLE10SP1) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE10_SP1');
		# Files excluded from the pattern, but included in the advisory:
		# samba-vscan-0.3.6b-42.69.6.i586.rpm     183.9 KB (188326)
		@PKGS_TO_CHECK       = qw(samba cifs-mount libsmbclient libsmbclient-devel samba-client samba-doc samba-krb-printing samba-pdb samba-winbind);
		$FIXED_VERSION       = '3.0.28-0.4.3';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} elsif ( SDP::SUSE::compareKernel(SLE10SP2) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE10_SP2');
		# Files excluded from the pattern, but included in the advisory:
		# samba-vscan-0.3.6b-42.72.i586.rpm       183.8 KB (188228)
		@PKGS_TO_CHECK       = qw(samba cifs-mount libsmbclient libsmbclient-devel samba-client samba-doc samba-krb-printing samba-pdb samba-winbind);
		$FIXED_VERSION       = '3.0.28-0.6';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} else {
		SDP::Core::printDebug('DISTRIBUTION', 'None Selected');
		SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: Outside the kernel scope");
	}

SDP::Core::printPatternResults();

exit;
