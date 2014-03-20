#!/usr/bin/perl

# Title:       Samba Security Advisory SUSE-SA:2007:068
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
	PROPERTY_NAME_COMPONENT."=Samba",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_Security",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_Security=http://www.novell.com/linux/security/advisories/2007_68_samba.html"
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
		# libsmbclient-32bit-9-200712041731.x86_64.rpm    613.2 KB (627950)
		# libsmbclient-64bit-9-200712041730.ppc.rpm       748.4 KB (766458)
		# samba-32bit-9-200712041731.x86_64.rpm   381.8 KB (390969)
		# samba-client-32bit-9-200712041731.x86_64.rpm    49.5 KB (50704)
		# samba-vscan-0.3.6b-0.26.5.i586.rpm      275.3 KB (281997)
		# samba-vscan-0.3.6b-0.26.5.ia64.rpm      332.5 KB (340537)
		# samba-vscan-0.3.6b-0.26.5.ppc.rpm       294.7 KB (301797)
		# samba-vscan-0.3.6b-0.26.5.x86_64.rpm    303.2 KB (310536)
		# samba-winbind-32bit-9-200712041731.x86_64.rpm   366.2 KB (375088)
		@PKGS_TO_CHECK       = qw(samba ibsmbclient libsmbclient libsmbclient-devel samba-client samba-doc samba-pdb samba-python samba-winbind);
		$FIXED_VERSION       = '3.0.20b-3.26';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} elsif ( SDP::SUSE::compareKernel(SLE10SP1) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE10');
		# Files excluded from the pattern, but included in the advisory:
		# samba-vscan-0.3.6b-42.67.i586.rpm       175.0 KB (179206)
		@PKGS_TO_CHECK       = qw(samba cifs-mount libmsrpc libmsrpc-devel libsmbclient libsmbclient-devel samba-client samba-doc samba-krb-printing samba-pdb samba-python samba-winbind);
		$FIXED_VERSION       = '3.0.24-2.36';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} else {
		SDP::Core::printDebug('DISTRIBUTION', 'None Selected');
		SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: Outside the kernel scope");
	}

SDP::Core::printPatternResults();

exit;
