#!/usr/bin/perl

# Title:       Xen SA Important SUSE-SU-2014:0470-1
# Description: fixes 15 vulnerabilities
# Modified:    2014 May 21
#
##############################################################################
# Copyright (C) 2014 SUSE LLC
##############################################################################
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.
#
#  Authors/Contributors:
#   Jason Record (jrecord@suse.com)
#
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
"META_CLASS=Security",
"META_CATEGORY=SLE",
"META_COMPONENT=Xen",
"PATTERN_ID=$PATTERN_ID",
"PRIMARY_LINK=META_LINK_Security",
"OVERALL=$GSTATUS",
"OVERALL_INFO=NOT SET",
"META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2014-04/msg00000.html",
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
my $NAME = 'LTSS Xen';
my $MAIN_PACKAGE = 'xen';
my $SEVERITY = 'Important';
my $TAG = 'SUSE-SU-2014:0470-1';
my %PACKAGES = ();
if ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
	%PACKAGES = (
		'xen' => '3.2.3_17040_28-0.6.21.3',
		'xen-devel' => '3.2.3_17040_28-0.6.21.3',
		'xen-doc-html' => '3.2.3_17040_28-0.6.21.3',
		'xen-doc-pdf' => '3.2.3_17040_28-0.6.21.3',
		'xen-doc-ps' => '3.2.3_17040_28-0.6.21.3',
		'xen-kmp-bigsmp' => '3.2.3_17040_28_2.6.16.60_0.113.9-0.6.21.3',
		'xen-kmp-debug' => '3.2.3_17040_28_2.6.16.60_0.113.9-0.6.21.3',
		'xen-kmp-default' => '3.2.3_17040_28_2.6.16.60_0.113.9-0.6.21.3',
		'xen-kmp-kdump' => '3.2.3_17040_28_2.6.16.60_0.113.9-0.6.21.3',
		'xen-kmp-kdumppae' => '3.2.3_17040_28_2.6.16.60_0.113.9-0.6.21.3',
		'xen-kmp-smp' => '3.2.3_17040_28_2.6.16.60_0.113.9-0.6.21.3',
		'xen-kmp-vmi' => '3.2.3_17040_28_2.6.16.60_0.113.9-0.6.21.3',
		'xen-kmp-vmipae' => '3.2.3_17040_28_2.6.16.60_0.113.9-0.6.21.3',
		'xen-libs' => '3.2.3_17040_28-0.6.21.3',
		'xen-libs-32bit' => '3.2.3_17040_28-0.6.21.3',
		'xen-tools' => '3.2.3_17040_28-0.6.21.3',
		'xen-tools-domU' => '3.2.3_17040_28-0.6.21.3',
		'xen-tools-ioemu' => '3.2.3_17040_28-0.6.21.3',
	);
	SDP::SUSE::securityAnnouncementPackageCheck($NAME, $MAIN_PACKAGE, $SEVERITY, $TAG, \%PACKAGES);
} else {
	SDP::Core::updateStatus(STATUS_ERROR, "ERROR: $NAME Security Announcement: Outside the kernel scope");
}
SDP::Core::printPatternResults();

exit;

