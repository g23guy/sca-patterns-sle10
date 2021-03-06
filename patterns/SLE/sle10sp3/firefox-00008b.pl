#!/usr/bin/perl

# Title:       Firefox 3 Security Advisory SUSE-SA:2010:015
# Description: Firefox 3 was updated to fix remote code execution issues, CVSS v2 Base Score: 10.0
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
	"META_LINK_Security=http://www.novell.com/linux/security/advisories/2010_15_mozilla.html"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $CHECKING            = 'Firefox';
	my $ADVISORY            = '10.0';
	my $TYPE                = 'Remote code execution';
	my @PKGS_TO_CHECK       = ();
	my $FIXED_VERSION       = '';
	my $SUCCESS             = 0;

	if ( SDP::SUSE::compareKernel(SLE11GA) >= 0 && SDP::SUSE::compareKernel(SLE11SP1) < 0 ) {
		SDP::Core::setStatus(STATUS_SUCCESS, "Level $ADVISORY $CHECKING $TYPE AVOIDED");

		@PKGS_TO_CHECK       = qw(MozillaFirefox MozillaFirefox-debuginfo MozillaFirefox-debugsource MozillaFirefox-translations);
		$FIXED_VERSION       = '3.5.8-0.1.1';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		@PKGS_TO_CHECK       = qw(mozilla-xulrunner191 mozilla-xulrunner191-32bit mozilla-xulrunner191-debuginfo mozilla-xulrunner191-debuginfo-32bit mozilla-xulrunner191-debuginfo-x86 mozilla-xulrunner191-debugsource mozilla-xulrunner191-devel mozilla-xulrunner191-gnomevfs mozilla-xulrunner191-gnomevfs-32bit mozilla-xulrunner191-gnomevfs-x86 mozilla-xulrunner191-translations mozilla-xulrunner191-translations-32bit mozilla-xulrunner191-translations-x86 mozilla-xulrunner191-x86);
		$FIXED_VERSION       = '1.9.1.8-1.1.1';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		@PKGS_TO_CHECK       = qw(mozilla-xulrunner191 mozilla-xulrunner191-32bit mozilla-xulrunner191-debuginfo mozilla-xulrunner191-debuginfo-32bit mozilla-xulrunner191-debuginfo-x86 mozilla-xulrunner191-debugsource mozilla-xulrunner191-devel mozilla-xulrunner191-gnomevfs mozilla-xulrunner191-gnomevfs-32bit mozilla-xulrunner191-gnomevfs-x86 mozilla-xulrunner191-translations mozilla-xulrunner191-translations-32bit mozilla-xulrunner191-translations-x86 mozilla-xulrunner191-x86);
		$FIXED_VERSION = '1.9.0.18-0.1.1';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		if ( ! $SUCCESS ) {
			SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: No package(s) installed");
		}
	} elsif ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
		SDP::Core::setStatus(STATUS_SUCCESS, "Level $ADVISORY $CHECKING $TYPE AVOIDED");

		@PKGS_TO_CHECK       = qw(MozillaFirefox MozillaFirefox-branding-upstream MozillaFirefox-debuginfo MozillaFirefox-translations);
		$FIXED_VERSION       = '3.5.8-0.4.1';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		@PKGS_TO_CHECK       = qw(mozilla-xulrunner191 mozilla-xulrunner191-32bit mozilla-xulrunner191-debuginfo mozilla-xulrunner191-devel mozilla-xulrunner191-gnomevfs mozilla-xulrunner191-gnomevfs-32bit mozilla-xulrunner191-translations mozilla-xulrunner191-translations-32bit python-xpcom191);
		$FIXED_VERSION       = '1.9.1.8-1.4.1';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		@PKGS_TO_CHECK       = qw(mozilla-xulrunner190 mozilla-xulrunner190-32bit mozilla-xulrunner190-debuginfo mozilla-xulrunner190-devel mozilla-xulrunner190-gnomevfs mozilla-xulrunner190-gnomevfs-32bit mozilla-xulrunner190-translations mozilla-xulrunner190-translations-32bit python-xpcom190);
		$FIXED_VERSION       = '1.9.0.18-0.4.1';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		if ( ! $SUCCESS ) {
			SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: No package(s) installed");
		}
	} elsif ( SDP::SUSE::compareKernel(SLE10SP2) >= 0 && SDP::SUSE::compareKernel(SLE10SP3) < 0 ) {
		SDP::Core::setStatus(STATUS_SUCCESS, "Level $ADVISORY $CHECKING $TYPE AVOIDED");

		@PKGS_TO_CHECK       = qw(MozillaFirefox MozillaFirefox-branding-upstream MozillaFirefox-debuginfo MozillaFirefox-translations);
		$FIXED_VERSION       = '3.5.8-0.3';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		@PKGS_TO_CHECK       = qw(mozilla-xulrunner191 mozilla-xulrunner191-32bit mozilla-xulrunner191-debuginfo mozilla-xulrunner191-devel mozilla-xulrunner191-gnomevfs mozilla-xulrunner191-gnomevfs-32bit mozilla-xulrunner191-translations mozilla-xulrunner191-translations-32bit python-xpcom191);
		$FIXED_VERSION       = '1.9.1.8-1.4.1';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		$SUCCESS++ if SDP::SUSE::securitySeverityPackageCheckNoError($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);

		@PKGS_TO_CHECK       = qw(mozilla-xulrunner190 mozilla-xulrunner190-debuginfo mozilla-xulrunner190-devel mozilla-xulrunner190-gnomevfs mozilla-xulrunner190-translations python-xpcom190);
		$FIXED_VERSION       = '1.9.0.18-0.4.1';
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
