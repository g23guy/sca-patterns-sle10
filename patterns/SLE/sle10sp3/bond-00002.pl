#!/usr/bin/perl

# Title:       Bonding Failure with bnx2x Driver
# Description: The use_carrier=1 option is needed in some configurations
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
	PROPERTY_NAME_CATEGORY."=Network",
	PROPERTY_NAME_COMPONENT."=Bond",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7005101"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub bondedNICS {
	SDP::Core::printDebug('> bondedNICS', 'BEGIN');
	my $RCODE = 0;
	my $ARRAY_REF = $_[0];
	my $FILENAME = 'network.txt';
	my @FILE_SECTIONS = ();
	my $CHECK = '';

	if ( SDP::Core::listSections($FILENAME, \@FILE_SECTIONS) ) {
		foreach $CHECK (@FILE_SECTIONS) {
			if ( $CHECK =~ /\/bonding\// ) {
				push(@$ARRAY_REF, $CHECK);
			}
		}
		$RCODE = scalar(@{$ARRAY_REF});
	}
	SDP::Core::printDebug("BONDS", "@$ARRAY_REF");
	SDP::Core::printDebug("< bondedNICS", "Returns: $RCODE");
	return $RCODE;
}

sub checkStatus {
	SDP::Core::printDebug('> checkStatus', 'BEGIN');
	my $RCODE = 0;
	my $BOND_REF = $_[0];
	my @BONDS_DOWN = ();
	my $FILE_OPEN = 'network.txt';
	my $SECTION;
	my $MIIDOWN;
	my $MIICNT;
	my @CONTENT = ();
	my @LINE_CONTENT = ();
	my $LINE = 0;

	# Look for bonds with Mii status down
	foreach $SECTION (@$BOND_REF) {
		@CONTENT = ();
		@LINE_CONTENT = ();
		$MIIDOWN = 0;
		$MIICNT = 0;
		if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
			foreach $_ (@CONTENT) {
				next if ( /^\s*$/ ); # Skip blank lines
				if ( /^MII Status:/i ) {
					$MIICNT++;
					@LINE_CONTENT = split(/\s+/, $_);
					$MIIDOWN++ if ( $LINE_CONTENT[$#LINE_CONTENT] =~ /down/i );
					SDP::Core::printDebug("STATUS Down: $MIIDOWN of $MIICNT", $_);
				}
			}
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Cannot find \"$SECTION\" section in $FILE_OPEN");
		}
		if ( $MIIDOWN == $MIICNT ) {
			push(@BONDS_DOWN, $SECTION);
		}
	}
	$MIIDOWN = scalar(@BONDS_DOWN);
	if ( $MIIDOWN ) {
		SDP::Core::printDebug("BONDS DOWN", "$MIIDOWN: @BONDS_DOWN");

		# Convert proc bonding value to it's matching configuration file
		my $I;
		for $I ( 0 .. $#BONDS_DOWN ) {
			@LINE_CONTENT = split(/\//, $BONDS_DOWN[$I]);
			my $BOND = pop(@LINE_CONTENT);
			$BONDS_DOWN[$I] = "/etc/sysconfig/network/ifcfg-" . $BOND;
		}
		SDP::Core::printDebug("BOND DOWN CONFIGS", "$MIIDOWN: @BONDS_DOWN");

		# Check for use_carrier=1 on bonds that are down
		foreach $SECTION (@BONDS_DOWN) {
			@CONTENT = ();
			@LINE_CONTENT = ();
			if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
				foreach $_ (@CONTENT) {
					next if ( /^\s*$/ ); # Skip blank lines
					if ( /^BONDING_MODULE_OPTS/i ) {
						SDP::Core::printDebug("PROCESSING", $_);
						@LINE_CONTENT = split(/-/, $SECTION);
						my $BOND = pop(@LINE_CONTENT);
						if ( /use_carrier=1/i ) {
							SDP::Core::updateStatus(STATUS_WARNING, "$BOND is down but use_carrier=1");
						} else {
							SDP::Core::updateStatus(STATUS_CRITICAL, "$BOND is down, consider use_carrier=1");
						}
						last;
					}
				}
			} else {
				SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Cannot find \"$SECTION\" section in $FILE_OPEN");
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "All bonds are up");
	}
	SDP::Core::printDebug("< checkStatus", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
		my %DRIVER = SDP::SUSE::getDriverInfo('bnx2x');
		my @BONDS = ();
		if ( $DRIVER{'loaded'} ) {
			bondedNICS(\@BONDS) ? checkStatus(\@BONDS) : SDP::Core::updateStatus(STATUS_ERROR, "ERROR: No active bonds, skipping bnx2x driver check");
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "Skip bnx2x driver test, driver NOT loaded");
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "Outside kernel scope, skipping bnx2x driver check");
	}
SDP::Core::printPatternResults();

exit;

