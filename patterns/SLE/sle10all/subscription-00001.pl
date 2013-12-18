#!/usr/bin/perl

# Title:       Checks Subscription to SLE10 Update Channel
# Description: The server must be subscribed to an update channel to receive updates. 
# Modified:    2013 Jun 25

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
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#  Authors/Contributors:
#     Jason Record (jrecord@suse.com)
#
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
	PROPERTY_NAME_CATEGORY."=Update",
	PROPERTY_NAME_COMPONENT."=Subscription",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7000387"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub check_subscribed_channel() {
	SDP::Core::printDebug('> check_subscribed_channel', 'BEGIN');
	my $FILE_OPEN = 'updates.txt';
	my $SECTION = 'rug ca';
	my @CONTENT = ();
	my @LINE_CONTENT = ();
	my $UP_SLE = '';
	my $UPS_SLE = -1; # no channel

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( /^\s*$/ ); # Skip blank lines
			next if ( /-*\+-*\+-*/ ); # skip header line
			next if ( /waking up zmd/i);
			$_ =~ s/\s+\|\s+/\|/g; # remove white space
			$_ =~ s/^\s+|\s+$//g;
			# get the update channels needed if subscribed to them
			@LINE_CONTENT = split(/\|/, $_);
			if ( $LINE_CONTENT[1] =~ /SLE.10-SP.-Updates|SLE.10-Updates/i ) {
				if ( $LINE_CONTENT[0] =~ /yes|ja/i ) {
					$UPS_SLE = 1; # sub'd to channel
				} else {
					$UPS_SLE = 0; # not sub'd to channel, but it exists.
				}
				$UP_SLE = $LINE_CONTENT[1];
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	if ( $UPS_SLE == 1 ) {
		SDP::Core::updateStatus(STATUS_ERROR, "Server subscribed to channel: $UP_SLE");
	} elsif ( $UPS_SLE == 0 ) {
		SDP::Core::updateStatus(STATUS_CRITICAL, "$UP_SLE is registered but not subscribed");
	} else {
		SDP::Core::updateStatus(STATUS_CRITICAL, "Server is not registered or subscribed to an update channel");
	}
	SDP::Core::printDebug('< check_subscribed_channel', "Returns: $UPS_SLE");
	return $UPS_SLE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( compareKernel(SLE10GA) >= 0 && compareKernel(SLE11GA) < 0 ) {
		check_subscribed_channel();
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "Outside the kernel scope, requires SLE10GA to SLE11GA");
	}
SDP::Core::printPatternResults();

exit;

