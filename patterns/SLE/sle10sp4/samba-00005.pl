#!/usr/bin/perl

# Title:       Samba SA SUSE-SU-2013:0325-1
# Description: Solves two vulnerabilities and has three fixes
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
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

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
	"META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2013-02/msg00018.html"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $NAME = 'Samba';
	my $MAIN_PACKAGE = '';
	my $SEVERITY = 'Important';
	my $TAG = 'SUSE-SU-2013:0325-1';
	my %PACKAGES = ();
	if ( SDP::SUSE::compareKernel(SLE10SP4) >= 0 && SDP::SUSE::compareKernel(SLE10SP5) < 0 ) {
		%PACKAGES = (
			'cifs-mount' => '3.0.36-0.13.24.1',
			'ldapsmb' => '1.34b-25.13.24.1',
			'libmsrpc' => '3.0.36-0.13.24.1',
			'libmsrpc-devel' => '3.0.36-0.13.24.1',
			'libsmbclient' => '3.0.36-0.13.24.1',
			'libsmbclient-32bit' => '3.0.36-0.13.24.1',
			'libsmbclient-64bit' => '3.0.36-0.13.24.1',
			'libsmbclient-devel' => '3.0.36-0.13.24.1',
			'libsmbclient-x86' => '3.0.36-0.13.24.1',
			'libsmbsharemodes' => '3.0.36-0.13.24.1',
			'libsmbsharemodes-devel' => '3.0.36-0.13.24.1',
			'samba' => '3.0.36-0.13.24.1',
			'samba-32bit' => '3.0.36-0.13.24.1',
			'samba-64bit' => '3.0.36-0.13.24.1',
			'samba-client' => '3.0.36-0.13.24.1',
			'samba-client-32bit' => '3.0.36-0.13.24.1',
			'samba-client-64bit' => '3.0.36-0.13.24.1',
			'samba-client-x86' => '3.0.36-0.13.24.1',
			'samba-doc' => '3.0.36-0.12.24.1',
			'samba-krb-printing' => '3.0.36-0.13.24.1',
			'samba-python' => '3.0.36-0.13.24.1',
			'samba-vscan' => '0.3.6b-43.13.24.1',
			'samba-winbind' => '3.0.36-0.13.24.1',
			'samba-winbind-32bit' => '3.0.36-0.13.24.1',
			'samba-winbind-64bit' => '3.0.36-0.13.24.1',
			'samba-winbind-x86' => '3.0.36-0.13.24.1',
			'samba-x86' => '3.0.36-0.13.24.1',
		);
		SDP::SUSE::securityAnnouncementPackageCheck($NAME, $MAIN_PACKAGE, $SEVERITY, $TAG, \%PACKAGES);
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: $NAME Security Announcement: Outside the kernel scope");
	}
SDP::Core::printPatternResults();

exit;

