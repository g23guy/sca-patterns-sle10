#!/usr/bin/perl

# Title:       Asynchronous Logouts with iSCSI
# Description: SLES 10 SP3 becomes unresponsive handling iSCSI asynchronous logouts
# Modified:    2013 Jun 27

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
	PROPERTY_NAME_CATEGORY."=Disk",
	PROPERTY_NAME_COMPONENT."=Base",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7005016",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=553685"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub iscsiSessions {
	SDP::Core::printDebug('> iscsiSessions', 'BEGIN');
	my $RCODE = 0;
	my $FILE_OPEN = 'fs-iscsi.txt';
	my $SECTION = 'iscsiadm -m session';
	my @CONTENT = ();

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( /^\s*$/ ); # Skip blank lines
			if ( /:.*:/ ) { # count lines with at least two colons as confirmed sessions to iscsi targets
				SDP::Core::printDebug("FOUND", $_);
				$RCODE++;
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	SDP::Core::printDebug("< iscsiSessions", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel('2.6.16.60-0.58.1') < 0 ) {
		my %SERVICE_INFO = SDP::SUSE::getServiceInfo('fs-iscsi.txt', 'open-iscsi');
		if ( iscsiSessions() ) {
			SDP::Core::updateStatus(STATUS_WARNING, "Check for iSCSI asynchronous logout mechanism");
		} else {
			if ( $SERVICE_INFO{'running'} ) {
				SDP::Core::updateStatus(STATUS_WARNING, "New iSCSI connections may be susceptible to being unresponsive");
			} else {
				SDP::Core::updateStatus(STATUS_ERROR, "ERROR: No active iSCSI sessions");
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Outside kernel scope, skipping iSCSI test");
	}
SDP::Core::printPatternResults();

exit;

