#!/usr/bin/perl

# Title:       libxml SA SUSE-SU-2013:1625-1
# Description: Fixes 8 vulnerabilities SLES10 SP3 LTSS
# Modified:    2013 Dec 04
#
##############################################################################
# Copyright (C) 2013 SUSE LLC
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
"META_COMPONENT=LibXML",
"PATTERN_ID=$PATTERN_ID",
"PRIMARY_LINK=META_LINK_Security",
"OVERALL=$GSTATUS",
"OVERALL_INFO=NOT SET",
"META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2013-11/msg00000.html",
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
my $NAME = 'LTSS LibXML';
my $MAIN_PACKAGE = '';
my $SEVERITY = 'Important';
my $TAG = 'SUSE-SU-2013:1625-1';
my %PACKAGES = ();
if ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
	%PACKAGES = (
		'libxml2' => '2.6.23-15.39.1',
		'libxml2-32bit' => '2.6.23-15.39.1',
		'libxml2-devel' => '2.6.23-15.39.1',
		'libxml2-devel-32bit' => '2.6.23-15.39.1',
		'libxml2-python' => '2.6.23-15.39.1',
	);
	SDP::SUSE::securityAnnouncementPackageCheck($NAME, $MAIN_PACKAGE, $SEVERITY, $TAG, \%PACKAGES);
} else {
	SDP::Core::updateStatus(STATUS_ERROR, "ERROR: $NAME Security Announcement: Outside the kernel scope");
}
SDP::Core::printPatternResults();

exit;

