#!/usr/bin/python

# Title:       General Support Ends for SLE10 SP4
# Description: Check for SLE10 SP4
# Modified:    2013 Nov 11
#
##############################################################################
# Copyright (C) 2013 SUSE LLC
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
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#  Authors/Contributors:
#   Jason Record (jrecord@suse.com)
#
##############################################################################

##############################################################################
# Module Definition
##############################################################################

import sys, os, Core, SUSE

##############################################################################
# Overriden (eventually or in part) from SDP::Core Module
##############################################################################

META_CLASS = "SLE"
META_CATEGORY = "Support"
META_COMPONENT = "Life Cycle"
PATTERN_ID = os.path.basename(__file__)
PRIMARY_LINK = "META_LINK_Security"
OVERALL = Core.TEMP
OVERALL_INFO = "NOT SET"
OTHER_LINKS = "META_LINK_Security=http://lists.opensuse.org/opensuse-security-announce/2013-11/msg00007.html|META_LINK_LifeCycle=http://support.novell.com/lifecycle/"

Core.init(META_CLASS, META_CATEGORY, META_COMPONENT, PATTERN_ID, PRIMARY_LINK, OVERALL, OVERALL_INFO, OTHER_LINKS)

##############################################################################
# Main Program Execution
##############################################################################

if( SUSE.compareKernel(SUSE.SLE10SP4) >= 0 and SUSE.compareKernel(SUSE.SLE10SP5) < 0 ):
	Core.updateStatus(Core.WARN, "General Support has ended for SLE10 SP4")
else:
	Core.updateStatus(Core.ERROR, "Outside kernel scope, skipping product life cycle test")

Core.printPatternResults()


