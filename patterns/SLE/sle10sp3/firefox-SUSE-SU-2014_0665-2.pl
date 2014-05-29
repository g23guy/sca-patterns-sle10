#!/usr/bin/perl

# Title:       Firefox SA Important SUSE-SU-2014:0665-2
# Description: fixes 8 vulnerabilities
# Modified:    2014 May 29
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
"META_COMPONENT=Firefox",
"PATTERN_ID=$PATTERN_ID",
"PRIMARY_LINK=META_LINK_Security",
"OVERALL=$GSTATUS",
"OVERALL_INFO=NOT SET",
"META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2014-05/msg00014.html",
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
my $NAME = 'LTSS Firefox';
my $MAIN_PACKAGE = 'MozillaFirefox';
my $SEVERITY = 'Important';
my $TAG = 'SUSE-SU-2014:0665-2';
my %PACKAGES = ();
if ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
	%PACKAGES = (
		'firefox-atk' => '1.28.0-0.7.3',
		'firefox-atk-32bit' => '1.28.0-0.7.3',
		'firefox-cairo' => '1.8.0-0.10.2',
		'firefox-cairo-32bit' => '1.8.0-0.10.2',
		'firefox-fontconfig' => '2.6.0-0.7.1',
		'firefox-fontconfig-32bit' => '2.6.0-0.7.1',
		'firefox-freetype2' => '2.3.7-0.35.1',
		'firefox-freetype2-32bit' => '2.3.7-0.35.1',
		'firefox-glib2' => '2.22.5-0.13.3',
		'firefox-glib2-32bit' => '2.22.5-0.13.3',
		'firefox-gtk2' => '2.18.9-0.9.2',
		'firefox-gtk2-32bit' => '2.18.9-0.9.2',
		'firefox-gtk2-lang' => '2.18.9-0.9.2',
		'firefox-libgcc_s1-32bit' => '4.7.2_20130108-0.22.1',
		'firefox-libgcc_s1' => '4.7.2_20130108-0.22.1',
		'firefox-libstdc++6-32bit' => '4.7.2_20130108-0.22.1',
		'firefox-libstdc++6' => '4.7.2_20130108-0.22.1',
		'firefox-pango' => '1.26.2-0.9.2',
		'firefox-pango-32bit' => '1.26.2-0.9.2',
		'firefox-pcre-32bit' => '7.8-0.8.1',
		'firefox-pcre' => '7.8-0.8.1',
		'firefox-pixman' => '0.16.0-0.7.1',
		'firefox-pixman-32bit' => '0.16.0-0.7.1',
		'MozillaFirefox' => '24.5.0esr-0.7.2',
		'MozillaFirefox-branding-SLED-24' => '0.12.1',
		'MozillaFirefox-translations' => '24.5.0esr-0.7.2',
		'mozilla-nspr-32bit' => '4.10.4-0.5.1',
		'mozilla-nspr' => '4.10.4-0.5.1',
		'mozilla-nspr-devel' => '4.10.4-0.5.1',
		'mozilla-nss' => '3.16-0.5.1',
		'mozilla-nss-32bit' => '3.16-0.5.1',
		'mozilla-nss-devel' => '3.16-0.5.1',
		'mozilla-nss-tools' => '3.16-0.5.1',
		'mozilla-xulrunner191' => '1.9.1.19-0.13.3',
		'mozilla-xulrunner191-32bit' => '1.9.1.19-0.13.3',
		'mozilla-xulrunner191-gnomevfs' => '1.9.1.19-0.13.3',
		'mozilla-xulrunner191-gnomevfs-32bit' => '1.9.1.19-0.13.3',
		'mozilla-xulrunner191-translations' => '1.9.1.19-0.13.3',
		'mozilla-xulrunner191-translations-32bit' => '1.9.1.19-0.13.3',
		'mozilla-xulrunner192' => '1.9.2.28-0.13.4',
		'mozilla-xulrunner192-32bit' => '1.9.2.28-0.13.4',
		'mozilla-xulrunner192-gnome' => '1.9.2.28-0.13.4',
		'mozilla-xulrunner192-gnome-32bit' => '1.9.2.28-0.13.4',
		'mozilla-xulrunner192-translations' => '1.9.2.28-0.13.4',
		'mozilla-xulrunner192-translations-32bit' => '1.9.2.28-0.13.4',
	);
	SDP::SUSE::securityAnnouncementPackageCheck($NAME, $MAIN_PACKAGE, $SEVERITY, $TAG, \%PACKAGES);
} else {
	SDP::Core::updateStatus(STATUS_ERROR, "ERROR: $NAME Security Announcement: Outside the kernel scope");
}
SDP::Core::printPatternResults();

exit;

