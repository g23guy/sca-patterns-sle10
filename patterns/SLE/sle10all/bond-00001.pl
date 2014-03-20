#!/usr/bin/perl

# Title:       Kernel panic on bonding with multiport NIC
# Description: A kernel panic is possible with certain multiport NIC bonding configurations.
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
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7004571"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub bondConfigSuspect {
	SDP::Core::printDebug('> bondConfigSuspect', 'BEGIN');
	my $RCODE = -1; # network bonding is assumed not configured
	my $BAD_BOND = 0;
	my $FILE_OPEN = 'network.txt';
	my $SECTION = '';
	my @CONTENT = ();
	my @LINE_CONTENT = ();
	my $LINE = 0;
	my @FILE_SECTIONS = ();
	my $BOND = '';

	if ( SDP::Core::listSections($FILE_OPEN, \@FILE_SECTIONS) ) {
		foreach $SECTION (@FILE_SECTIONS) {
			if ( $SECTION =~ /\/etc\/sysconfig\/network\/ifcfg-/ ) {
				@CONTENT = ();
				if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
					foreach $_ (@CONTENT) {
						$LINE++;
						next if ( /^\s*$/ ); # Skip blank lines
						if ( /^BONDING_MODULE_OPTS/i ) {
							$RCODE = 0; # mark network bonding as configured
							SDP::Core::printDebug("LINE $LINE", $_);
							my (undef, $BOPT) = split(/'/); # requires the BONDING_MODULE_OPTS='key=value key=value' format. Missing quotes(') will fail.
							@LINE_CONTENT = split(/\s+/, $BOPT);
							my $OPT_SET = 0;
							foreach $BOPT (@LINE_CONTENT) {
								if ( $BOPT =~ /mode=active-backup|miimon=10|use_carrier=0/i ) {
									$OPT_SET++;
								}
							}
							if ( $OPT_SET == 3 ) {
								$BAD_BOND++;
								SDP::Core::printDebug(" BOND", "Marked Suspect");
							} else {
								SDP::Core::printDebug(" BOND", "Configuration Ignored");
							}
							last;
						}
					}
				}
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "No sections found in $FILE_OPEN");
	}
	$RCODE += $BAD_BOND;
	SDP::Core::printDebug("< bondConfigSuspect", "Bad Bonds: $BAD_BOND, Returns: $RCODE");
	return $RCODE;
}

sub bondInUseMessages {
	SDP::Core::printDebug('> bondInUseMessages', 'BEGIN');
	my $RCODE = 0;
	my $FILE_OPEN = 'messages.txt';
	my $SECTION = '/var/log/messages';
	my @CONTENT = ();
	my @LINE_CONTENT = ();
	my $LINE = 0;

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			$LINE++;
			next if ( /^\s*$/ ); # Skip blank lines
			if ( /kernel:\s+bonding:.*Warning:\s+the permanent HWaddr of.*is still in use by.*Set the HWaddr of.*to a different address to avoid conflicts/i ) {
				SDP::Core::printDebug("LINE $LINE", $_);
				$RCODE++;
				last;
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	SDP::Core::printDebug("< bondInUseMessages", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( SDP::SUSE::compareKernel(SLE10SP1) >= 0 && SDP::SUSE::compareKernel(SLE10SP2) <= 0 ) {
		my $BOND_SUSPECTED = bondConfigSuspect();
		if ( $BOND_SUSPECTED < 0 ) {
			SDP::Core::updateStatus(STATUS_ERROR, "ABORT: Network bonding not configured");
		} elsif ( $BOND_SUSPECTED > 0) {
			if ( bondInUseMessages() ) {
				SDP::Core::updateStatus(STATUS_CRITICAL, "Susceptible to kernel panic if using multiport NICs");
			} else {
				SDP::Core::updateStatus(STATUS_WARNING, "Server may be susceptible to panics if using multiport NICs");
			}
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "Multiport NIC kernel panic not suspected");
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ABORT: Outside kernel scope, bonding check skipped.");
	}
SDP::Core::printPatternResults();

exit;

