#!/usr/bin/perl

# Title:       Updating GRUB Fails to Boot
# Description: After updating to grub-0.97-16.26.1 on SLE10SP3 the system does not reboot properly.
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
	PROPERTY_NAME_CATEGORY."=GRUB",
	PROPERTY_NAME_COMPONENT."=Base",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7005934",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=604284"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub extOnBoot {
	SDP::Core::printDebug('> extOnBoot', 'BEGIN');
	my $RCODE = 0;
	my $FILE_OPEN = 'fs-diskio.txt';
	my $SECTION = '/etc/fstab';
	my @CONTENT = ();

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) { # first check for /boot on it's own partition
			next if ( /^\s*$/ ); # Skip blank lines
			if ( /\/boot\s+ext/i ) {
				SDP::Core::printDebug("PROCESSING", $_);
				$RCODE++;
				last;
			}
		}
		if ( ! $RCODE ) {
			foreach $_ (@CONTENT) { # next check for /boot on the / partition
				next if ( /^\s*$/ ); # Skip blank lines
				if ( /\/\s+ext/i ) {
					SDP::Core::printDebug("PROCESSING", $_);
					$RCODE++;
					last;
				}
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: extOnBoot(): Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	SDP::Core::printDebug("< extOnBoot", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
		my $RPM_NAME = 'grub';
		my $VERSION_TO_COMPARE = '0.97-16.26.1';
		my $RPM_COMPARISON = SDP::SUSE::compareRpm($RPM_NAME, $VERSION_TO_COMPARE);
		if ( $RPM_COMPARISON == 2 ) {
			SDP::Core::updateStatus(STATUS_ERROR, "ERROR: RPM $RPM_NAME Not Installed");
		} elsif ( $RPM_COMPARISON > 2 ) {
			SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Multiple Versions of $RPM_NAME RPM are Installed");
		} else {
			if ( $RPM_COMPARISON == 0 ) {
				if ( extOnBoot() ) {
					SDP::Core::updateStatus(STATUS_CRITICAL, "Update or backrev GRUB to avoid reboot failure");
				} else {
					SDP::Core::updateStatus(STATUS_ERROR, "No update specific GRUB failure observed on non-ext /boot");
				}
			} else {
				SDP::Core::updateStatus(STATUS_ERROR, "No update specific GRUB failure observed");
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Skipping grub failure test, SLE10SP3 required");
	}
SDP::Core::printPatternResults();

exit;

