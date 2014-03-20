#!/usr/bin/perl

# Title:       Fiber Channel (FC) Recovery fails on qlogic HBA
# Description: Lost fiber connections may not recovery properly
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
	PROPERTY_NAME_CATEGORY."=Kernel",
	PROPERTY_NAME_COMPONENT."=HBA",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7005436",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=571837"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub checkQlogicErrors {
	SDP::Core::printDebug('> checkQlogicErrors', 'BEGIN');
	my $RCODE = 0;
	my $STATE = 0;
	my @LINE_CONTENT = ();
	my $FILE_OPEN = 'messages.txt';
	my $SECTION = '/var/log/messages';
	my @CONTENT = ();
	my %LINKS_DOWN = ();
	my %LINKS_UP = ();

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (reverse(@CONTENT)) {
			next if ( /^\s*$/ ); # Skip blank lines
			if ( /qla2xxx (.*): LOOP UP detected/ ) {
				SDP::Core::printDebug("PROCESSING", $_);
				$LINKS_UP{$1} = 1;
			} elsif ( /qla2xxx (.*): LOOP DOWN detected/ ) {
				SDP::Core::printDebug("PROCESSING", $_);
				if ( ! $LINKS_UP{$1} ) {
					$LINKS_DOWN{$1} = 1;
					$RCODE++;
				}
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	if ( $RCODE ) {
		my @KEYS_DOWN = keys(%LINKS_DOWN);
		SDP::Core::updateStatus(STATUS_CRITICAL, "Qlogic HBA Links are Down: @KEYS_DOWN");
	} else {
		my $KEYSTR = '';
		my @KEYS_UP = keys(%LINKS_UP);
		$KEYSTR = ": @KEYS_UP" if ( @KEYS_UP );
		SDP::Core::updateStatus(STATUS_WARNING, "Qlogic HBA Links May Be Susceptible to Failed Reconnects$KEYSTR");
	}
	SDP::Core::printDebug("< checkQlogicErrors", "Returns: $RCODE");
	return $RCODE;
}

sub qlogicFibre {
	SDP::Core::printDebug('> qlogicFibre', 'BEGIN');
	my $RCODE = 0;
	my $FILE_OPEN = 'hardware.txt';
	my $SECTION = 'lspci -b';
	my @CONTENT = ();

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( m/^\s*$/ ); # Skip blank lines
			if ( /Fibre.*QLogic|QLogic.*Fibre/i ) {
				SDP::Core::printDebug("PROCESSING", $_);
				$RCODE++;
				last;
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: qlogicFibre(): Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	SDP::Core::printDebug("< qlogicFibre", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( qlogicFibre() ) {
		if ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
			my $RPM_NAME = 'qlogic-firmware';
			my $VERSION_TO_COMPARE = '1.0-13.23.1';
			my $RPM_COMPARISON = SDP::SUSE::compareRpm($RPM_NAME, $VERSION_TO_COMPARE);
			if ( $RPM_COMPARISON == 2 ) {
				SDP::Core::updateStatus(STATUS_ERROR, "ERROR: RPM $RPM_NAME Not Installed");
			} elsif ( $RPM_COMPARISON > 2 ) {
				SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Multiple Versions of $RPM_NAME RPM are Installed");
			} else {
				if ( $RPM_COMPARISON <= 0 ) {
					checkQlogicErrors();
				} else {
					SDP::Core::updateStatus(STATUS_ERROR, "QLogic disconnect issue not observed");
				}                       
			}
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "ABORT: Outside the kernel scope, skipping QLogic HBA test");
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ABORT: No QLogic Fibre Card Found, skipping QLogic HBA test");
	}
SDP::Core::printPatternResults();

exit;

