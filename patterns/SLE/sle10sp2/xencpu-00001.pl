#!/usr/bin/perl

# Title:       VMX, SVM, or other CPU flags missing after updating Xen
# Description: Missing CPU flags may result in multiple failure symptoms.
# Modified:    2013 Jun 28

##############################################################################
#  Copyright (C) 2013 SUSE LLC
##############################################################################
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; version 2 of the License.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, see <http://www.gnu.org/licenses/>.
#

#  Authors/Contributors:
#   Jason Record (jrecord@suse.com)

##############################################################################

##############################################################################
# Module Definition
##############################################################################
use strict;
use warnings;
use SDP::Core;
use SDP::SUSE;

##############################################################################
# Overriden (eventually or in part) from SDP::Core Module
##############################################################################

@PATTERN_RESULTS = (
	PROPERTY_NAME_CLASS."=SLE",
	PROPERTY_NAME_CATEGORY."=Virtualization",
	PROPERTY_NAME_COMPONENT."=CPU Flags",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7001447",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=423671"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if  ( SDP::SUSE::compareKernel(SLE10SP2) >= 0 && SDP::SUSE::compareKernel(SLE10SP3) < 0 ) {
		my @RPMS = qw(kernel-xen kernel-xenpae);
		my $VERSION_TO_COMPARE = '2.6.16.60-0.33';
		my $RPM_NAME = '';
		my $BROKEN = 0;
		my $XEN_INSTALLED = 0;

		foreach $RPM_NAME (@RPMS) {
			my $RPM_COMPARISON = SDP::SUSE::compareRpm($RPM_NAME, $VERSION_TO_COMPARE);
			if ( $RPM_COMPARISON == 2 ) {
				SDP::Core::updateStatus(STATUS_PARTIAL, "RPM $RPM_NAME Not Installed");
			} elsif ( $RPM_COMPARISON > 2 ) {
				SDP::Core::updateStatus(STATUS_PARTIAL, "Multiple Versions of $RPM_NAME RPM are Installed");
			} else {
				SDP::Core::updateStatus(STATUS_PARTIAL, "RPM $RPM_NAME Installed");
				$XEN_INSTALLED++;
				if ( $RPM_COMPARISON < 0 ) {
					$BROKEN++;
				}
			}
		}
		if ( $XEN_INSTALLED ) {
			if ( $BROKEN ) {
				SDP::Core::updateStatus(STATUS_WARNING, "Xen susceptible to HVM install and migration issues");		
			} else {
				SDP::Core::updateStatus(STATUS_ERROR, "Dropped Xen HVM CPU flags not detected");		
			}
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "Xen kernel not installed: Security, xencpu-00001.pl");
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "Outside the kernel scope: Security, xencpu-00001.pl");
	}
SDP::Core::printPatternResults();

exit;

