#!/usr/bin/python
#
# Title:       Important Security Announcement for Xen SUSE-SU-2016:0658-1
# Description: Security fixes for SUSE Linux Enterprise 10 SP4 LTSS
# Source:      Security Announcement Parser v1.3.0
# Modified:    2016 Mar 08
#
##############################################################################
# Copyright (C) 2016 SUSE LLC
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
META_COMPONENT = "Xen"
PATTERN_ID = os.path.basename(__file__)
PRIMARY_LINK = "META_LINK_Security"
OVERALL = Core.TEMP
OVERALL_INFO = "NOT SET"
OTHER_LINKS = "META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2016-03/msg00013.html"
Core.init(META_CLASS, META_CATEGORY, META_COMPONENT, PATTERN_ID, PRIMARY_LINK, OVERALL, OVERALL_INFO, OTHER_LINKS)

LTSS = True
NAME = 'Xen'
MAIN = ''
SEVERITY = 'Important'
TAG = 'SUSE-SU-2016:0658-1'
PACKAGES = {}
SERVER = SUSE.getHostInfo()

if ( SERVER['DistroVersion'] == 10):
	if ( SERVER['DistroPatchLevel'] == 4 ):
		PACKAGES = {
			'xen': '3.2.3_17040_46-0.23.2',
			'xen-devel': '3.2.3_17040_46-0.23.2',
			'xen-doc-html': '3.2.3_17040_46-0.23.2',
			'xen-doc-pdf': '3.2.3_17040_46-0.23.2',
			'xen-doc-ps': '3.2.3_17040_46-0.23.2',
			'xen-kmp-bigsmp': '3.2.3_17040_46_2.6.16.60_0.132.6-0.23.2',
			'xen-kmp-debug': '3.2.3_17040_46_2.6.16.60_0.132.6-0.23.2',
			'xen-kmp-default': '3.2.3_17040_46_2.6.16.60_0.132.6-0.23.2',
			'xen-kmp-kdump': '3.2.3_17040_46_2.6.16.60_0.132.6-0.23.2',
			'xen-kmp-kdumppae': '3.2.3_17040_46_2.6.16.60_0.132.6-0.23.2',
			'xen-kmp-smp': '3.2.3_17040_46_2.6.16.60_0.132.6-0.23.2',
			'xen-kmp-vmi': '3.2.3_17040_46_2.6.16.60_0.132.6-0.23.2',
			'xen-kmp-vmipae': '3.2.3_17040_46_2.6.16.60_0.132.6-0.23.2',
			'xen-libs': '3.2.3_17040_46-0.23.2',
			'xen-libs-32bit': '3.2.3_17040_46-0.23.2',
			'xen-tools': '3.2.3_17040_46-0.23.2',
			'xen-tools-domU': '3.2.3_17040_46-0.23.2',
			'xen-tools-ioemu': '3.2.3_17040_46-0.23.2',
		}
		SUSE.securityAnnouncementPackageCheck(NAME, MAIN, LTSS, SEVERITY, TAG, PACKAGES)
	else:
		Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the service pack scope")
else:
	Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the distribution scope")
Core.printPatternResults()

