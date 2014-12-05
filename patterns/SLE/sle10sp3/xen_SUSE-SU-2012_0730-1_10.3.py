#!/usr/bin/python
#
# Title:       Critical Security Announcement for Xen SUSE-SU-2012:0730-1
# Description: Security fixes for SUSE Linux Enterprise 10 SP3
# Source:      Security Announcement Parser v1.1.7
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
META_COMPONENT = "Xen"
PATTERN_ID = os.path.basename(__file__)
PRIMARY_LINK = "META_LINK_Security"
OVERALL = Core.TEMP
OVERALL_INFO = "NOT SET"
OTHER_LINKS = "META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2012-06/msg00008.html"
Core.init(META_CLASS, META_CATEGORY, META_COMPONENT, PATTERN_ID, PRIMARY_LINK, OVERALL, OVERALL_INFO, OTHER_LINKS)

LTSS = True
NAME = 'Xen'
MAIN = ''
SEVERITY = 'Critical'
TAG = 'SUSE-SU-2012:0730-1'
PACKAGES = {}
SERVER = SUSE.getHostInfo()

if ( SERVER['DistroVersion'] == 10):
	if ( SERVER['DistroPatchLevel'] == 3 ):
		PACKAGES = {
			'xen': '3.2.3_17040_28-0.6.11.1',
			'xen-devel': '3.2.3_17040_28-0.6.11.1',
			'xen-doc-html': '3.2.3_17040_28-0.6.11.1',
			'xen-doc-pdf': '3.2.3_17040_28-0.6.11.1',
			'xen-doc-ps': '3.2.3_17040_28-0.6.11.1',
			'xen-kmp-bigsmp': '3.2.3_17040_28_2.6.16.60_0.83.131-0.6.11.1',
			'xen-kmp-debug': '3.2.3_17040_28_2.6.16.60_0.83.131-0.6.11.1',
			'xen-kmp-default': '3.2.3_17040_28_2.6.16.60_0.83.131-0.6.11.1',
			'xen-kmp-kdump': '3.2.3_17040_28_2.6.16.60_0.83.131-0.6.11.1',
			'xen-kmp-kdumppae': '3.2.3_17040_28_2.6.16.60_0.83.131-0.6.11.1',
			'xen-kmp-smp': '3.2.3_17040_28_2.6.16.60_0.83.131-0.6.11.1',
			'xen-kmp-vmi': '3.2.3_17040_28_2.6.16.60_0.83.131-0.6.11.1',
			'xen-kmp-vmipae': '3.2.3_17040_28_2.6.16.60_0.83.131-0.6.11.1',
			'xen-libs': '3.2.3_17040_28-0.6.11.1',
			'xen-libs-32bit': '3.2.3_17040_28-0.6.11.1',
			'xen-tools': '3.2.3_17040_28-0.6.11.1',
			'xen-tools-domU': '3.2.3_17040_28-0.6.11.1',
			'xen-tools-ioemu': '3.2.3_17040_28-0.6.11.1',
		}
		SUSE.securityAnnouncementPackageCheck(NAME, MAIN, LTSS, SEVERITY, TAG, PACKAGES)
	else:
		Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the service pack scope")
else:
	Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the distribution scope")
Core.printPatternResults()

