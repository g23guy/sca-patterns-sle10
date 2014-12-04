#!/usr/bin/python
#
# Title:       Important Security Announcement for Firefox SUSE-SU-2013:0471-1
# Description: Security fixes for SUSE Linux Enterprise 10 SP4
# Source:      Security Announcement Parser v1.1.6
# Modified:    2014 Dec 04
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

import os
import Core
import SUSE

META_CLASS = "Security"
META_CATEGORY = "SLE"
META_COMPONENT = "Firefox"
PATTERN_ID = os.path.basename(__file__)
PRIMARY_LINK = "META_LINK_Security"
OVERALL = Core.TEMP
OVERALL_INFO = "NOT SET"
OTHER_LINKS = "META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2013-03/msg00029.html"
Core.init(META_CLASS, META_CATEGORY, META_COMPONENT, PATTERN_ID, PRIMARY_LINK, OVERALL, OVERALL_INFO, OTHER_LINKS)

LTSS = False
NAME = 'Firefox'
MAIN = ''
SEVERITY = 'Important'
TAG = 'SUSE-SU-2013:0471-1'
PACKAGES = {}
SERVER = SUSE.getHostInfo()

if ( SERVER['DistroVersion'] == 10):
	if ( SERVER['DistroPatchLevel'] == 4 ):
		PACKAGES = {
			'MozillaFirefox-branding-SLED': '7-0.10.4',
			'mozilla-nspr': '4.9.4-0.6.3',
			'mozilla-nss-devel': '3.14.1-0.6.3',
			'mozilla-nspr-64bit': '4.9.4-0.6.3',
			'mozilla-nss-64bit': '3.14.1-0.6.3',
			'mhtml-firefox': '0.5-1.13.4',
			'mozilla-nspr-32bit': '4.9.4-0.6.3',
			'mozilla-nss-32bit': '3.14.1-0.6.3',
			'mozilla-nss-tools': '3.14.1-0.6.3',
			'mozilla-nss-x86': '3.14.1-0.6.3',
			'MozillaFirefox-translations': '17.0.4esr-0.7.1',
			'mozilla-nspr-devel': '4.9.4-0.6.3',
			'MozillaFirefox': '17.0.4esr-0.7.1',
			'mozilla-nspr-x86': '4.9.4-0.6.3',
			'mozilla-nss': '3.14.1-0.6.3',
		}
		SUSE.securityAnnouncementPackageCheck(NAME, MAIN, LTSS, SEVERITY, TAG, PACKAGES)
	else:
		Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the service pack scope")
else:
	Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the distribution scope")
Core.printPatternResults()

