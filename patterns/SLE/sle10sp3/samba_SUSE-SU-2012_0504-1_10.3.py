#!/usr/bin/python
#
# Title:       Critical Security Announcement for Samba SUSE-SU-2012:0504-1
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
META_COMPONENT = "Samba"
PATTERN_ID = os.path.basename(__file__)
PRIMARY_LINK = "META_LINK_Security"
OVERALL = Core.TEMP
OVERALL_INFO = "NOT SET"
OTHER_LINKS = "META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2012-04/msg00009.html"
Core.init(META_CLASS, META_CATEGORY, META_COMPONENT, PATTERN_ID, PRIMARY_LINK, OVERALL, OVERALL_INFO, OTHER_LINKS)

LTSS = False
NAME = 'Samba'
MAIN = ''
SEVERITY = 'Critical'
TAG = 'SUSE-SU-2012:0504-1'
PACKAGES = {}
SERVER = SUSE.getHostInfo()

if ( SERVER['DistroVersion'] == 10):
	if ( SERVER['DistroPatchLevel'] == 3 ):
		PACKAGES = {
			'cifs-mount': '3.0.36-0.13.20.1',
			'ldapsmb': '1.34b-25.13.20.1',
			'libmsrpc': '3.0.36-0.13.20.1',
			'libmsrpc-devel': '3.0.36-0.13.20.1',
			'libsmbclient': '3.0.36-0.13.20.1',
			'libsmbclient-32bit': '3.0.36-0.13.20.1',
			'libsmbclient-64bit': '3.0.36-0.13.20.1',
			'libsmbclient-devel': '3.0.36-0.13.20.1',
			'libsmbclient-x86': '3.0.36-0.13.20.1',
			'samba': '3.0.36-0.13.20.1',
			'samba-32bit': '3.0.36-0.13.20.1',
			'samba-64bit': '3.0.36-0.13.20.1',
			'samba-client': '3.0.36-0.13.20.1',
			'samba-client-32bit': '3.0.36-0.13.20.1',
			'samba-client-64bit': '3.0.36-0.13.20.1',
			'samba-client-x86': '3.0.36-0.13.20.1',
			'samba-doc': '3.0.36-0.12.20.1',
			'samba-krb-printing': '3.0.36-0.13.20.1',
			'samba-python': '3.0.36-0.13.20.1',
			'samba-vscan': '0.3.6b-43.13.20.1',
			'samba-winbind': '3.0.36-0.13.20.1',
			'samba-winbind-32bit': '3.0.36-0.13.20.1',
			'samba-winbind-64bit': '3.0.36-0.13.20.1',
			'samba-winbind-x86': '3.0.36-0.13.20.1',
			'samba-x86': '3.0.36-0.13.20.1',
		}
		SUSE.securityAnnouncementPackageCheck(NAME, MAIN, LTSS, SEVERITY, TAG, PACKAGES)
	else:
		Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the service pack scope")
else:
	Core.updateStatus(Core.ERROR, "ERROR: " + NAME + " Security Announcement: Outside the distribution scope")
Core.printPatternResults()

