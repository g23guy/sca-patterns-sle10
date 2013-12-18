#!/usr/bin/perl

# Title:       Some LVM pvmove operations can hang
# Description: pvmove hangs when using the command pvmove /dev/dm-X /dev/dm-Y
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
	PROPERTY_NAME_CATEGORY."=Disk",
	PROPERTY_NAME_COMPONENT."=LVM",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7004403",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=535642"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub searchForPvmove {
	SDP::Core::printDebug('> searchForPvmove', 'BEGIN');
	my $RCODE = 0;
	my $FILE_OPEN = 'lvm.txt';
	my @FILE_SECTIONS = ();
	my @CHECK_SECTIONS = ();
	my $CHECK = '';
	my $SECTION = '';
	my $LINE;

	if ( SDP::Core::listSections($FILE_OPEN, \@FILE_SECTIONS) ) {
		foreach $CHECK (@FILE_SECTIONS) { # Use only archive and backup sections
			if ( $CHECK =~ /^\/etc\/lvm\/archive\/\S\S+|^\/etc\/lvm\/backup\/\S\S+/i ) {
				push(@CHECK_SECTIONS, $CHECK);
			}
		}
		$CHECK = scalar(@CHECK_SECTIONS);
		SDP::Core::printDebug("CHECK_SECTIONS", "$CHECK: @CHECK_SECTIONS");
		if ( @CHECK_SECTIONS ) {
			foreach $SECTION (@CHECK_SECTIONS) {
				my @CONTENT = ();
				SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT);
				foreach $LINE (@CONTENT) {
					next if ( $LINE =~ /^$/ ); # Skip blank lines
					if ( $LINE =~ /description.*executing.*pvmove/i ) {
						SDP::Core::printDebug("PROCESSING", $LINE);
						my @LINE_CONTENT = split(/\s+|\'|\"/, $LINE);
						my $I;
						my $STATE = 0;
						my $PVMOVES = 0;
						foreach $I (@LINE_CONTENT) {
							if ( $STATE ) {
								SDP::Core::printDebug(" CMD", "$I");
								if ( $I =~ /-n|--name/ ) { # valid pvmove if logical volume name specified
									$STATE = 0;
									last;
								} elsif ( $I =~ /\/dev\/dm-/ ) { # count the number of volumes being moved without -n or --name
									$PVMOVES++;
								}
							} elsif ( $I =~ /pvmove/ ) { # just process the pvmove command and it's options
								SDP::Core::printDebug(" CMD", "$I");
								$STATE = 1;
							}
						}
						$RCODE++ if ( $PVMOVES > 1 );
					}
				}
				last if ( $RCODE ); # Don't look in any other section if multiple moves found
			}
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Cannot find archive or backup sections in $FILE_OPEN");
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "No sections found in $FILE_OPEN");
	}

	if ( $RCODE ) {
		SDP::Core::updateStatus(STATUS_WARNING, "Moving multiple volumes with pvmove");
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "Not Found: Moving multiple volumes with pvmove");
	}
	SDP::Core::printDebug("< searchForPvmove", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( SDP::SUSE::compareKernel(SLE10GA) >= 0 && SDP::SUSE::compareKernel(SLE11GA) < 0 ) {
		searchForPvmove();
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Outside kernel scope, skipping LVM test");
	}
SDP::Core::printPatternResults();

exit;

