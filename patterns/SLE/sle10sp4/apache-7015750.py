#!/usr/bin/python

# Title:       Apache Fails to Start
# Description: Apache will not start after update
# Modified:    2014 Oct 10
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
import re
import Core
import SUSE

##############################################################################
# Overriden (eventually or in part) from SDP::Core Module
##############################################################################

META_CLASS = "SLE"
META_CATEGORY = "Apache"
META_COMPONENT = "Start"
PATTERN_ID = os.path.basename(__file__)
PRIMARY_LINK = "META_LINK_TID"
OVERALL = Core.TEMP
OVERALL_INFO = "NOT SET"
OTHER_LINKS = "META_LINK_TID=https://www.novell.com/support/kb/doc.php?id=7015750|META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=900183"

Core.init(META_CLASS, META_CATEGORY, META_COMPONENT, PATTERN_ID, PRIMARY_LINK, OVERALL, OVERALL_INFO, OTHER_LINKS)

##############################################################################
# Local Function Definitions
##############################################################################

def errorFound():
	fileOpen = "web.txt"
	section = "/var/log/apache2/rcapache2.out"
	content = {}
	errorStr = re.compile("undefined symbol.*ap_timeout_parameter_parse", re.IGNORECASE)
	if Core.getSection(fileOpen, section, content):
		for line in content:
			if errorStr.search(content[line]):
				return True
	return False

##############################################################################
# Main Program Execution
##############################################################################

SERVER = SUSE.getHostInfo()
IN_SCOPE = False
RPM_NAME = 'apache2'
if( SERVER['DistroVersion'] == 10 and SERVER['DistroPatchLevel'] == 4 ):
	RPM_VERSION = '2.2.3-16.50.1'
	IN_SCOPE = True
elif( SERVER['DistroVersion'] == 10 and SERVER['DistroPatchLevel'] == 3 ):
	RPM_VERSION = '2.2.3-16.32.51.2'
	IN_SCOPE = True

if( IN_SCOPE ):
	SERVICE = 'apache2'
	if( SUSE.packageInstalled(RPM_NAME) ):
		INSTALLED_VERSION = SUSE.compareRPM(RPM_NAME, RPM_VERSION)
		if( INSTALLED_VERSION == 0 ):
			if( errorFound() ):
				Core.updateStatus(Core.CRIT, "Detected Apache failed start issue log errors, update server to apply " + RPM_NAME + " fixes")
			else:
				SERVICE_INFO = SUSE.getServiceInfo(SERVICE)
				if( SERVICE_INFO['OnForRunLevel'] ):
					Core.updateStatus(Core.CRIT, "Detected Apache failed start issue, update server to apply " + RPM_NAME + " fixes")
				else:
					Core.updateStatus(Core.WARN, "Apache mail fail to start if used, update server to apply " + RPM_NAME + " fixes")
		else:
			Core.updateStatus(Core.IGNORE, "Apache failed start issue AVOIDED")
	else:
		Core.updateStatus(Core.ERROR, "ERROR: " + RPM_NAME + " not installed")
else:
	Core.updateStatus(Core.ERROR, "Outside Distribution Version and Patch Level scope, Skipping")

Core.printPatternResults()

