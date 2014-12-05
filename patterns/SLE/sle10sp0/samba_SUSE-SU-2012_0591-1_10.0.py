#!/usr/bin/python
#
# Title:       Important Security Announcement for Samba SUSE-SU-2012:0591-1
# Description: Security fixes for SUSE Linux Enterprise 10 SP0
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
META_COMPONENT = "Samba"
PATTERN_ID = os.path.basename(__file__)
PRIMARY_LINK = "META_LINK_Security"
OVERALL = Core.TEMP
OVERALL_INFO = "NOT SET"
OTHER_LINKS = "META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2012-05/msg00003.html"
Core.init(META_CLASS, META_CATEGORY, META_COMPONENT, PATTERN_ID, PRIMARY_LINK, OVERALL, OVERALL_INFO, OTHER_LINKS)

LTSS = False
NAME = 'Samba'
MAIN = ''
SEVERITY = 'Important'
TAG = 'SUSE-SU-2012:0591-1'
PACKAGES = {}
SERVER = SUSE.getHostInfo()

if ( SERVER['DistroVersion'] == 10):
	if ( SERVER['DistroPatchLevel'] == 0 ):
		PACKAGES = {
			'libnetapi-devel': '3.4.3-0.43.1',
			'libnetapi0': '3.4.3-0.43.1',
			'libtalloc-devel': '3.4.3-0.43.1',
			'libtalloc1': '3.4.3-0.43.1',
			'libtdb-devel': '3.4.3-0.43.1',
			'libtdb1': '3.4.3-0.43.1',
			'libwbclient-devel': '3.4.3-0.43.1',
			'libwbclient0': '3.4.3-0.43.1',
			'samba-gplv3': '3.4.3-0.43.1',
			'samba-gplv3-client': '3.4.3-0.43.1',
			'samba-gplv3-doc': '3.4.3-0.43.1',
			'samba-gplv3-krb-printing': '3.4.3-0.43.1',
			'samba-gplv3-winbind': '3.4.3-0.43.1',
		}
		SUSE.securityAnnouncementPackageCheck(NAME, MAIN, LTSS, SEVERITY, TAG, PACKAGES)
	else:
		Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the service pack scope")
else:
	Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the distribution scope")
Core.printPatternResults()

