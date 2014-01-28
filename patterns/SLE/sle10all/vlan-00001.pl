#!/usr/bin/perl

# Title:       VLAN device ifup fails
# Description: Not possible to ifup a VLAN device after configuration with YaST
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
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

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
	PROPERTY_NAME_CATEGORY."=Network",
	PROPERTY_NAME_COMPONENT."=VLAN",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7006714",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=625103"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub checkGetcfgError {
	SDP::Core::printDebug('> checkGetcfgError', 'BEGIN');
	my $RCODE = 0;
	my @LINE_CONTENT = ();
	my $FILE_OPEN = 'y2log.txt';
	my $SECTION = 'y2log';
	my @CONTENT = ();
	my $STATE = 0;
	my $IFCFG = '';

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( m/^\s*$/ ); # Skip blank lines
			if ( $STATE ) {
				SDP::Core::printDebug("PROCESSING", $_);
				if ( ! /ShellCommand\.cc/ ) {
					SDP::Core::printDebug(" STATE CHANGE", "OFF" );
					$STATE = 0;
				} elsif ( /interface (.*) is not up/i ) { 
					$IFCFG = $1;
					SDP::Core::printDebug(" INTERFACE DOWN", $IFCFG);
					$RCODE++;
					$STATE = 0;
					last;
				}
			} elsif ( /ShellCommand\.cc.*Error in getcfg-interface.*get_config\.c/i ) {
				SDP::Core::printDebug(" STATE CHANGE", "ON" );
				$STATE = 1;
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: checkGetcfgError(): Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	if ( $RCODE ) {
		$FILE_OPEN = 'network.txt';
		$SECTION = "network status";
		@CONTENT = ();
		my $NICSTATE = 0; # -1 down, 0 not found, 1 up
		if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
			foreach $_ (@CONTENT) {
				next if ( m/^\s*$/ ); # Skip blank lines
				if ( /$IFCFG.*down/i ) {
					$NICSTATE = -1;
					last;					
				} elsif ( /$IFCFG.*ip address/i ) {
					$NICSTATE = 1;
				}
			}
			if ( $NICSTATE == -1 ) {
				SDP::Core::updateStatus(STATUS_CRITICAL, "Yast2-network issue, failed to configure network interface: $IFCFG");
			} elsif ( $NICSTATE == 1 ) {
				SDP::Core::updateStatus(STATUS_ERROR, "Detected yast2-network configuration error, but interface is up: $IFCFG");
			} else {
				SDP::Core::updateStatus(STATUS_WARNING, "Detected yast2-network configuration error attempting to configure interface: $IFCFG");
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: No getcfg errors detected, skipping vlan test");
	}
	SDP::Core::printDebug("< checkGetcfgError", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( SDP::SUSE::compareKernel(SLE10SP2) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
		my $RPM_NAME = 'yast2-network';
		my $VERSION_TO_COMPARE = '2.13.135-0.4.1';
		my $RPM_COMPARISON = SDP::SUSE::compareRpm($RPM_NAME, $VERSION_TO_COMPARE);
		if ( $RPM_COMPARISON == 2 ) {
			SDP::Core::updateStatus(STATUS_ERROR, "ERROR: RPM $RPM_NAME Not Installed");
		} elsif ( $RPM_COMPARISON > 2 ) {
			SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Multiple Versions of $RPM_NAME RPM are Installed");
		} else {
			if ( $RPM_COMPARISON <= 0 ) {
				checkGetcfgError();
			} else {
				SDP::Core::updateStatus(STATUS_ERROR, "ERROR: The $RPM_NAME RPM version avoids vlan confuration error");
			}			
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Outside kernel scope, skipping vlan test");
	}
SDP::Core::printPatternResults();

exit;

