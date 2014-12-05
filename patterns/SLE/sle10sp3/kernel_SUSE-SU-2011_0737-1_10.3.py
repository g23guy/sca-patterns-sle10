#!/usr/bin/python
#
# Title:       Critical Security Announcement for kernel SUSE-SU-2011:0737-1
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
META_COMPONENT = "kernel"
PATTERN_ID = os.path.basename(__file__)
PRIMARY_LINK = "META_LINK_Security"
OVERALL = Core.TEMP
OVERALL_INFO = "NOT SET"
OTHER_LINKS = "META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2011-07/msg00000.html"
Core.init(META_CLASS, META_CATEGORY, META_COMPONENT, PATTERN_ID, PRIMARY_LINK, OVERALL, OVERALL_INFO, OTHER_LINKS)

LTSS = False
NAME = 'kernel'
MAIN = ''
SEVERITY = 'Critical'
TAG = 'SUSE-SU-2011:0737-1'
PACKAGES = {}
SERVER = SUSE.getHostInfo()

if ( SERVER['DistroVersion'] == 10):
	if ( SERVER['DistroPatchLevel'] == 3 ):
		PACKAGES = {
			'kernel-bigsmp': '2.6.16.60-0.81.2',
			'kernel-debug': '2.6.16.60-0.81.2',
			'kernel-default': '2.6.16.60-0.81.2',
			'kernel-iseries64': '2.6.16.60-0.81.2',
			'kernel-kdump': '2.6.16.60-0.81.2',
			'kernel-kdumppae': '2.6.16.60-0.81.2',
			'kernel-ppc64': '2.6.16.60-0.81.2',
			'kernel-smp': '2.6.16.60-0.81.2',
			'kernel-source': '2.6.16.60-0.81.2',
			'kernel-syms': '2.6.16.60-0.81.2',
			'kernel-vmi': '2.6.16.60-0.81.2',
			'kernel-vmipae': '2.6.16.60-0.81.2',
			'kernel-xen': '2.6.16.60-0.81.2',
			'kernel-xenpae': '2.6.16.60-0.81.2',
		}
		SUSE.securityAnnouncementPackageCheck(NAME, MAIN, LTSS, SEVERITY, TAG, PACKAGES)
	else:
		Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the service pack scope")
else:
	Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the distribution scope")
Core.printPatternResults()

