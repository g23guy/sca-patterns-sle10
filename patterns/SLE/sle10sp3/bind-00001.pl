#!/usr/bin/perl

# Title:       Bind Open File Descriptor Errors
# Description: DNS caching server fails
# Modified:    2013 Jun 24

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
	PROPERTY_NAME_CATEGORY."=DNS",
	PROPERTY_NAME_COMPONENT."=Files",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7008883"
);




##############################################################################
# Local Function Definitions
##############################################################################

sub errorFound {
	SDP::Core::printDebug('> errorFound', 'BEGIN');
	my $RCODE = 0;
	my $FILE_OPEN = 'messages.txt';
	my $SECTION = '/var/log/messages';
	my @CONTENT = ();

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (reverse(@CONTENT)) {
			next if ( m/^\s*$/ ); # Skip blank lines
			if ( /named.*socket: too many open.*file descriptors/i ) {
				SDP::Core::printDebug("PROCESSING", $_);
				$RCODE++;
				last;
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: errorFound(): Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	SDP::Core::printDebug("< errorFound", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
		my $SERVICE_NAME = 'named';
		my %SERVICE_INFO = SDP::SUSE::getServiceInfo($SERVICE_NAME);
		if ( $SERVICE_INFO{'runlevelstatus'} > 0 ) {
			if ( errorFound() ) {
				SDP::Core::updateStatus(STATUS_CRITICAL, "Detected $SERVICE_NAME file descriptor errors");
			} else {
				SDP::Core::updateStatus(STATUS_ERROR, "No named file descriptor errors found");
			}
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "Named Not in Use, Skipping Bind Test");
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "SLE10SP3 Required, Skipping Bind Test");
	}
SDP::Core::printPatternResults();

exit;

