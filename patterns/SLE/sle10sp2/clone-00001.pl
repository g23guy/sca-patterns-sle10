#!/usr/bin/perl

# Title:       Autoyast Clone System Hanging or Causing malloc Errors
# Description: Creating an autoyast system clone file hangs or generates malloc() errors
# Modified:    2013 Jun 27

##############################################################################
#  Copyright (C) 2013,2012 SUSE LLC
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
	PROPERTY_NAME_CATEGORY."=YaST",
	PROPERTY_NAME_COMPONENT."=Clone",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7003938",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=516131"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub searchSignal6 {
	SDP::Core::printDebug('> searchSignal6', 'BEGIN');
	my $RCODE = 0;
	my $FILE_OPEN = 'y2log.txt';
	my $SECTION = '/var/log/YaST2/y2log';
	my @CONTENT = ();
	my @LINE_CONTENT = ();
	my $LINE = 0;

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			$LINE++;
			next if ( /^\s*$/ );                  # Skip blank lines
			if ( /genericfrontend.*got signal 6 at YCP file Printerdb.ycp:376/i ) {
				SDP::Core::printDebug("LINE $LINE", $_);
				$RCODE = 1;
				last;
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	if ( $RCODE ) {
		SDP::Core::updateStatus(STATUS_WARNING, "Autoyast Clone System may hang or cause malloc() errors");
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "Autoyast Clone System does not appear to hang or cause malloc() errors");
	}
	SDP::Core::printDebug("< searchSignal6", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( SDP::SUSE::compareKernel(SLE10SP2) >= 0 && SDP::SUSE::compareKernel(SLE10SP3) < 0 ) {
		my $RPM_NAME = 'yast2-printer';
		my $VERSION_TO_COMPARE = '2.13.32-1.13';
		my $RPM_COMPARISON = SDP::SUSE::compareRpm($RPM_NAME, $VERSION_TO_COMPARE);
		if ( $RPM_COMPARISON == 2 ) {
			SDP::Core::updateStatus(STATUS_ERROR, "RPM $RPM_NAME Not Installed");
		} elsif ( $RPM_COMPARISON > 2 ) {
			SDP::Core::updateStatus(STATUS_ERROR, "Multiple Versions of $RPM_NAME RPM are Installed");
		} else {
			if ( $RPM_COMPARISON <= 0 ) {
				searchSignal6();
			} else {
				SDP::Core::updateStatus(STATUS_ERROR, "PPM $RPM_NAME-$VERSION_TO_COMPARE required to check autoyast clone system issue");
			}                       
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "SLE10 required to check autoyast clone system issue");
	}
SDP::Core::printPatternResults();

exit;

