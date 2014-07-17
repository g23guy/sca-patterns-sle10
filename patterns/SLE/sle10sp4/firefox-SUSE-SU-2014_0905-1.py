#!/usr/bin/python

# Title:       Firefox SA Important SUSE-SU-2014:0905-1
# Description: fixes 7 vulnerabilities
# Modified:    2014 Jul 17
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

import os
import Core
import SUSE

##############################################################################
# Overriden (eventually or in part) from SDP::Core Module
##############################################################################

META_CLASS = "Security"
META_CATEGORY = "SLE"
META_COMPONENT = "Firefox"
PATTERN_ID = os.path.basename(__file__)
PRIMARY_LINK = "META_LINK_Security"
OVERALL = Core.TEMP
OVERALL_INFO = "NOT SET"
OTHER_LINKS = "META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2014-07/msg00011.html"

Core.init(META_CLASS, META_CATEGORY, META_COMPONENT, PATTERN_ID, PRIMARY_LINK, OVERALL, OVERALL_INFO, OTHER_LINKS)

##############################################################################
# Main Program Execution
##############################################################################

LTSS = True
NAME = 'Firefox'
MAIN = 'MozillaFirefox'
SEVERITY = 'Important'
TAG = 'SUSE-SU-2014:0905-1'
PACKAGES = {}
SERVER = SUSE.getHostInfo()

if ( SERVER['DistroVersion'] == 10 and SERVER['DistroPatchLevel'] == 4 or SERVER['DistroPatchLevel'] == 3 ):
	PACKAGES = {
		'MozillaFirefox': '24.6.0esr-0.5.4',
		'MozillaFirefox-branding-SLED-24': '0.12.4',
		'MozillaFirefox-translations': '24.6.0esr-0.5.4',
		'mozilla-nspr-32bit': '4.10.6-0.5.4',
		'mozilla-nspr': '4.10.6-0.5.4',
		'mozilla-nspr-devel': '4.10.6-0.5.4',
		'mozilla-nss': '3.16.1-0.5.4',
		'mozilla-nss-32bit': '3.16.1-0.5.4',
		'mozilla-nss-devel': '3.16.1-0.5.4',
		'mozilla-nss-tools': '3.16.1-0.5.4',
	}
	SUSE.securityAnnouncementPackageCheck(NAME, MAIN, LTSS, SEVERITY, TAG, PACKAGES)
else:
	Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the distribution scope")

Core.printPatternResults()

