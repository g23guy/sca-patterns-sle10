#!/usr/bin/perl

# Title:       Kernel SA Important SUSE-SU-2014:0536-1
# Description: solves 42 vulnerabilities and has 8 fixes
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
"META_COMPONENT=Kernel",
"PATTERN_ID=$PATTERN_ID",
"PRIMARY_LINK=META_LINK_Security",
"OVERALL=$GSTATUS",
"OVERALL_INFO=NOT SET",
"META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2014-04/msg00013.html",
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
my $NAME = 'LTSS Kernel';
my $MAIN_PACKAGE = '';
my $SEVERITY = 'Important';
my $TAG = 'SUSE-SU-2014:0536-1';
my %PACKAGES = ();
if ( SDP::SUSE::compareKernel(SLE10SP4) >= 0 && SDP::SUSE::compareKernel(SLE10SP5) < 0 ) {
	%PACKAGES = (
		'kernel-bigsmp' => '2.6.16.60-0.105.1',
		'kernel-debug' => '2.6.16.60-0.105.1',
		'kernel-default' => '2.6.16.60-0.105.1',
		'kernel-kdump' => '2.6.16.60-0.105.1',
		'kernel-kdumppae' => '2.6.16.60-0.105.1',
		'kernel-smp' => '2.6.16.60-0.105.1',
		'kernel-source' => '2.6.16.60-0.105.1',
		'kernel-syms' => '2.6.16.60-0.105.1',
		'kernel-vmi' => '2.6.16.60-0.105.1',
		'kernel-vmipae' => '2.6.16.60-0.105.1',
		'kernel-xen' => '2.6.16.60-0.105.1',
		'kernel-xenpae' => '2.6.16.60-0.105.1',
	);
	SDP::SUSE::securityAnnouncementPackageCheck($NAME, $MAIN_PACKAGE, $SEVERITY, $TAG, \%PACKAGES);
} else {
	SDP::Core::updateStatus(STATUS_ERROR, "ERROR: $NAME Security Announcement: Outside the kernel scope");
}
SDP::Core::printPatternResults();

exit;

