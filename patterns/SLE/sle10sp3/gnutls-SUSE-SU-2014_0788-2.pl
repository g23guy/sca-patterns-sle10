#!/usr/bin/perl

# Title:       GnuTLS SA Important SUSE-SU-2014:0788-2
# Description: fixes four vulnerabilities
# Modified:    2014 Jun 25
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
"META_COMPONENT=GnuTLS",
"PATTERN_ID=$PATTERN_ID",
"PRIMARY_LINK=META_LINK_Security",
"OVERALL=$GSTATUS",
"OVERALL_INFO=NOT SET",
"META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2014-06/msg00017.html",
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
my $NAME = 'LTSS GnuTLS';
my $MAIN_PACKAGE = 'gnutls';
my $SEVERITY = 'Important';
my $TAG = 'SUSE-SU-2014:0788-2';
my %PACKAGES = ();
if ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel(SLE10SP5) < 0 ) {
	%PACKAGES = (
		'gnutls' => '1.2.10-13.40.1',
		'gnutls-32bit' => '1.2.10-13.40.1',
		'gnutls-devel' => '1.2.10-13.40.1',
		'gnutls-devel-32bit' => '1.2.10-13.40.1',
	);
	SDP::SUSE::securityAnnouncementPackageCheck($NAME, $MAIN_PACKAGE, $SEVERITY, $TAG, \%PACKAGES);
} else {
	SDP::Core::updateStatus(STATUS_ERROR, "ERROR: $NAME Security Announcement: Outside the kernel scope");
}
SDP::Core::printPatternResults();

exit;

