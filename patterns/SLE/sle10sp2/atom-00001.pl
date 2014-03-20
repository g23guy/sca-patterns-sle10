#!/usr/bin/perl

# Title:       Atom Package Conflicts During Update
# Description: Error messages about atom packages may be presented.
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
	PROPERTY_NAME_CATEGORY."=Update",
	PROPERTY_NAME_COMPONENT."=Conflict",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7003264"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub detectAtomErrors {
	SDP::Core::printDebug('> detectAtomErrors', 'BEGIN');
	my $RCODE = 0;
	my $ARRAY_REF = $_[0];
	my @ATOM_PACKAGES = ();
	my %ATOM_TABLE = ();
	my $ATOM_PKG = '';
	my $FILE_OPEN = 'y2log.txt';
	my $SECTION = '/y2log';
	my @CONTENT = ();

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( m/^\s*$/ ); # Skip blank lines
			if ( /ResolverContext.cc\(addError\).*atom:(.*)\s*Error/ ) {
				$ATOM_PKG = $1;
				$ATOM_PKG =~ s/\s+//;
				SDP::Core::printDebug("PROCESSING", $ATOM_PKG);
				$ATOM_TABLE{$ATOM_PKG} = 1;
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: detectAtomErrors(): Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	$RCODE = scalar keys %ATOM_TABLE;
	if ( $RCODE ) {
		@$ARRAY_REF = keys %ATOM_TABLE;
	}
	SDP::Core::printDebug("< detectAtomErrors", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my @BAD_ATOM = ();
	if ( detectAtomErrors(\@BAD_ATOM) ) {
		SDP::Core::updateStatus(STATUS_WARNING, "Detected Atom Packge Update Errors for: @BAD_ATOM");
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: No atom errors");
	}
SDP::Core::printPatternResults();

exit;

