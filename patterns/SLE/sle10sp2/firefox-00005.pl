#!/usr/bin/perl

# Title:       Firefox 3 Security Advisory SUSE-SA:2009:042
# Description: Firefox 3 was updated to fix remote code execution security issues, Severity 8 of 10.
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
	PROPERTY_NAME_COMPONENT."=Firefox",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_Security",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_Security=http://www.novell.com/linux/security/advisories/2009_42_firefox.html"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $CHECKING            = 'Firefox';
	my $ADVISORY            = '8';
	my $TYPE                = 'Remote code execution';
	my @PKGS_TO_CHECK       = ();
	my $FIXED_VERSION       = '';
	my $SUCCESS             = 0;

	if  ( SDP::SUSE::compareKernel(SLE10SP2) >= 0 && SDP::SUSE::compareKernel(SLE10SP3) < 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE10SP2');
		SDP::Core::setStatus(STATUS_SUCCESS, "Level $ADVISORY $CHECKING $TYPE AVOIDED");
		my %HOST_INFO = SDP::SUSE::getHostInfo();
		if ( $HOST_INFO{'architecture'} =~ /ppc/i ) {
			$FIXED_VERSION    = '3.0.12-0.5.1';
			SDP::Core::printDebug('ARCHITECTURE', 'PPC');
		} else {
			SDP::Core::printDebug('ARCHITECTURE', 'NOT PPC');
			$FIXED_VERSION    = '3.0.12-0.4';
		}
		@PKGS_TO_CHECK       = qw(MozillaFirefox MozillaFirefox-branding-upstream MozillaFirefox-debuginfo MozillaFirefox-translations);
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		@PKGS_TO_CHECK       = qw(MozillaFirefox MozillaFirefox-branding-upstream MozillaFirefox-debuginfo MozillaFirefox-translations);
		$FIXED_VERSION       = '3.0.12-0.5.1';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		@PKGS_TO_CHECK       = qw(mozilla-xulrunner190 mozilla-xulrunner190-32bit mozilla-xulrunner190-debuginfo mozilla-xulrunner190-devel mozilla-xulrunner190-gnomevfs mozilla-xulrunner190-gnomevfs-32bit mozilla-xulrunner190-translations mozilla-xulrunner190-translations-32bit python-xpcom190);
		$FIXED_VERSION       = '1.9.0.12-1.4';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		@PKGS_TO_CHECK       = qw(firefox3-cairo firefox3-cairo-32bit firefox3-cairo-debuginfo firefox3-cairo-devel firefox3-cairo-doc);
		$FIXED_VERSION       = '1.2.4-0.4.2';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		@PKGS_TO_CHECK       = qw(firefox3-atk firefox3-atk-32bit firefox3-atk-debuginfo firefox3-atk-devel firefox3-atk-doc);
		$FIXED_VERSION       = '1.12.3-0.4.2';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		@PKGS_TO_CHECK       = qw(firefox3-pango firefox3-pango-32bit firefox3-pango-debuginfo firefox3-pango-devel firefox3-pango-doc);
		$FIXED_VERSION       = '1.14.5-0.4.2';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		@PKGS_TO_CHECK       = qw(firefox3-glib2 firefox3-glib2-32bit firefox3-glib2-debuginfo firefox3-glib2-devel firefox3-glib2-doc);
		$FIXED_VERSION       = '2.12.4-0.4.2';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		@PKGS_TO_CHECK       = qw(MozillaFirefox-branding-SLED);
		$FIXED_VERSION       = '3.0.3-7.4.2';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		@PKGS_TO_CHECK       = qw(firefox3-gtk2 firefox3-gtk2-32bit firefox3-gtk2-debuginfo firefox3-gtk2-devel firefox3-gtk2-doc);
		$FIXED_VERSION       = '2.10.6-0.4.2';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		if ( ! $SUCCESS ) {
			SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: No package(s) installed");
		}
	} else {
		SDP::Core::printDebug('DISTRIBUTION', 'None Selected');
		SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: Outside the kernel scope");
	}

SDP::Core::printPatternResults();

exit;
