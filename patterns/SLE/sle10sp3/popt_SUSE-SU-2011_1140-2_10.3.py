#!/usr/bin/python
#
# Title:       Important Security Announcement for popt SUSE-SU-2011:1140-2
# Description: Security fixes for SUSE Linux Enterprise 10 SP3
# Source:      Security Announcement Parser v1.1.8
# Modified:    2014 Dec 05
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
META_COMPONENT = "popt"
PATTERN_ID = os.path.basename(__file__)
PRIMARY_LINK = "META_LINK_Security"
OVERALL = Core.TEMP
OVERALL_INFO = "NOT SET"
OTHER_LINKS = "META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2011-11/msg00002.html"
Core.init(META_CLASS, META_CATEGORY, META_COMPONENT, PATTERN_ID, PRIMARY_LINK, OVERALL, OVERALL_INFO, OTHER_LINKS)

LTSS = False
NAME = 'popt'
MAIN = ''
SEVERITY = 'Important'
TAG = 'SUSE-SU-2011:1140-2'
PACKAGES = {}
SERVER = SUSE.getHostInfo()

if ( SERVER['DistroVersion'] == 10):
	if ( SERVER['DistroPatchLevel'] == 3 ):
		PACKAGES = {
			'popt': '1.7-271.37.38.7',
			'popt-32bit': '1.7-271.37.38.7',
			'popt-64bit': '1.7-271.37.38.7',
			'popt-devel': '1.7-271.37.38.7',
			'popt-devel-32bit': '1.7-271.37.38.7',
			'popt-devel-64bit': '1.7-271.37.38.7',
			'popt-x86': '1.7-271.37.38.7',
			'rpm': '4.4.2-43.38.38.7',
			'rpm-devel': '4.4.2-43.38.38.7',
			'rpm-python': '4.4.2-43.38.38.7',
		}
		SUSE.securityAnnouncementPackageCheck(NAME, MAIN, LTSS, SEVERITY, TAG, PACKAGES)
	else:
		Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the service pack scope")
else:
	Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the distribution scope")
Core.printPatternResults()

