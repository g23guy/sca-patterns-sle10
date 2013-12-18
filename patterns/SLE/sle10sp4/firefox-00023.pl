#!/usr/bin/perl

# Title:       Firefox SA SUSE-SU-2013:0049-1
# Description: Several security fixes
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
	PROPERTY_NAME_COMPONENT."=Firefox",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_Security",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2013-01/msg00007.html"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $NAME = 'Firefox';
	my $MAIN_PACKAGE = 'MozillaFirefox';
	my $SEVERITY = 'Important';
	my $TAG = 'SUSE-SU-2013:0049-1';
	my %PACKAGES = ();
	if ( SDP::SUSE::compareKernel(SLE10SP4) >= 0 && SDP::SUSE::compareKernel(SLE10SP5) < 0 ) {
		%PACKAGES = (
			'MozillaFirefox' => '10.0.12-0.6.1',
			'MozillaFirefox-branding-upstream' => '10.0.12-0.6.1',
			'MozillaFirefox-translations' => '10.0.12-0.6.1',
			'mozilla-nspr-32bit' => '4.9.4-0.6.1',
			'mozilla-nspr' => '4.9.4-0.6.1',
			'mozilla-nspr-64bit' => '4.9.4-0.6.1',
			'mozilla-nspr-devel' => '4.9.4-0.6.1',
			'mozilla-nspr-x86' => '4.9.4-0.6.1',
			'mozilla-nss' => '3.14.1-0.6.1',
			'mozilla-nss-32bit' => '3.14.1-0.6.1',
			'mozilla-nss-64bit' => '3.14.1-0.6.1',
			'mozilla-nss-devel' => '3.14.1-0.6.1',
			'mozilla-nss-tools' => '3.14.1-0.6.1',
			'mozilla-nss-x86' => '3.14.1-0.6.1',
		);
		SDP::SUSE::securityAnnouncementPackageCheck($NAME, $MAIN_PACKAGE, $SEVERITY, $TAG, \%PACKAGES);
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: $NAME Security Announcement: Outside the kernel scope");
	}
SDP::Core::printPatternResults();

exit;

