#!/usr/bin/perl

# Title:       Samba Security Advisory SUSE-SA:2007:065
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
	"META_LINK_Security=http://www.novell.com/linux/security/advisories/2007_65_samba.html"
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

	if  ( SDP::SUSE::compareKernel(SLE9SP5) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE9');
		# Files excluded from the pattern, but included in the advisory:
		# libsmbclient-32bit-9-200711231829.x86_64.rpm    613.1 KB (627841)
		# libsmbclient-64bit-9-200711240034.ppc.rpm       748.7 KB (766697)
		# samba-32bit-9-200711231829.x86_64.rpm   381.7 KB (390910)
		# samba-client-32bit-9-200711231829.x86_64.rpm    49.2 KB (50436)
		# samba-vscan-0.3.6b-0.26.3.i586.rpm      275.1 KB (281801)
		# samba-vscan-0.3.6b-0.26.3.ia64.rpm      332.3 KB (340339)
		# samba-vscan-0.3.6b-0.26.3.ppc.rpm       294.3 KB (301446)
		# samba-vscan-0.3.6b-0.26.3.x86_64.rpm    302.8 KB (310160)
		# samba-winbind-32bit-9-200711231829.x86_64.rpm   366.0 KB (374807)
		@PKGS_TO_CHECK       = qw(samba libsmbclient libsmbclient-devel samba-client samba-doc samba-pdb samba-python samba-winbind);
		$FIXED_VERSION       = '3.0.20b-3.24';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} elsif ( SDP::SUSE::compareKernel(SLE10SP1) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE10');
		# Files excluded from the pattern, but included in the advisory:
		# samba-vscan-0.3.6b-42.62.i586.rpm       174.7 KB (178957)
		@PKGS_TO_CHECK       = qw(samba cifs-mount libmsrpc libmsrpc-devel libsmbclient libsmbclient-devel samba-client samba-krb-printing samba-pdb samba-python samba-winbind);
		$FIXED_VERSION       = '3.0.24-2.33';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} else {
		SDP::Core::printDebug('DISTRIBUTION', 'None Selected');
		SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: Outside the kernel scope");
	}

SDP::Core::printPatternResults();

exit;
