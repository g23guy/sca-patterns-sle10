#!/usr/bin/perl

# Title:       Xen SA SUSE-SU-2012:1606-1
# Description: Fixes two vulnerabilities
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
	PROPERTY_NAME_COMPONENT."=Xen",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_Security",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2012-12/msg00007.html"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $NAME = 'Xen';
	my $MAIN_PACKAGE = 'xen-tools';
	my $SEVERITY = 'Important';
	my $TAG = 'SUSE-SU-2012:1606-1';
	my %PACKAGES = ();
	if ( SDP::SUSE::compareKernel(SLE10SP4) >= 0 && SDP::SUSE::compareKernel(SLE10SP5) < 0 ) {
		%PACKAGES = (
			'xen' => '3.2.3_17040_44-0.7.1',
			'xen-devel' => '3.2.3_17040_44-0.7.1',
			'xen-doc-html' => '3.2.3_17040_44-0.7.1',
			'xen-doc-pdf' => '3.2.3_17040_44-0.7.1',
			'xen-doc-ps' => '3.2.3_17040_44-0.7.1',
			'xen-kmp-bigsmp' => '3.2.3_17040_44_2.6.16.60_0.99.13-0.7.1',
			'xen-kmp-debug' => '3.2.3_17040_44_2.6.16.60_0.99.13-0.7.1',
			'xen-kmp-default' => '3.2.3_17040_44_2.6.16.60_0.99.13-0.7.1',
			'xen-kmp-kdump' => '3.2.3_17040_44_2.6.16.60_0.99.13-0.7.1',
			'xen-kmp-kdumppae' => '3.2.3_17040_44_2.6.16.60_0.99.13-0.7.1',
			'xen-kmp-smp' => '3.2.3_17040_44_2.6.16.60_0.99.13-0.7.1',
			'xen-kmp-vmi' => '3.2.3_17040_44_2.6.16.60_0.99.13-0.7.1',
			'xen-kmp-vmipae' => '3.2.3_17040_44_2.6.16.60_0.99.13-0.7.1',
			'xen-libs' => '3.2.3_17040_44-0.7.1',
			'xen-libs-32bit' => '3.2.3_17040_44-0.7.1',
			'xen-tools' => '3.2.3_17040_44-0.7.1',
			'xen-tools-domU' => '3.2.3_17040_44-0.7.1',
			'xen-tools-ioemu' => '3.2.3_17040_44-0.7.1',
		);
		SDP::SUSE::securityAnnouncementPackageCheck($NAME, $MAIN_PACKAGE, $SEVERITY, $TAG, \%PACKAGES);
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: $NAME Security Announcement: Outside the kernel scope");
	}
SDP::Core::printPatternResults();

exit;

