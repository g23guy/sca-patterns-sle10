#!/usr/bin/perl

# Title:       Automounter on s390x Fails to Start
# Description: s390x autofs5 reports undefined symbol: krb5_cc_get_principal
# Modified:    2013 Jun 27

##############################################################################
#  Copyright (C) 2013,2011 SUSE LLC
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
	PROPERTY_NAME_CATEGORY."=AutoFS",
	PROPERTY_NAME_COMPONENT."=Symbol",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7005217",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=572934"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub autofsFailureConfirmed {
	SDP::Core::printDebug('> autofsFailureConfirmed', 'BEGIN');
	my $RCODE = 0;
	my $FILE_OPEN = 'messages.txt';
	my $SECTION = '/var/log/messages';
	my @CONTENT = ();
	my @LINE_CONTENT = ();

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( /^\s*$/ ); # Skip blank lines
			if ( /automount.*cannot.*lookup module ldap.*undefined symbol.*krb5_cc_get_principal/i ) {
				SDP::Core::printDebug("PROCESSING", $_);
				$RCODE++;
				last;
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	SDP::Core::printDebug("< autofsFailureConfirmed", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my %HOST_INFO = SDP::SUSE::getHostInfo();
	if ( SDP::SUSE::compareKernel(SLE10SP3) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 && $HOST_INFO{'architecture'} =~ /s390/i ) {
		my $RPM_NAME = 'autofs5';
		my $VERSION_TO_COMPARE = '5.0.3-0.5.41';
		my $RPM_COMPARISON = SDP::SUSE::compareRpm($RPM_NAME, $VERSION_TO_COMPARE);
		if ( $RPM_COMPARISON == 2 ) {
			SDP::Core::updateStatus(STATUS_ERROR, "ERROR: RPM $RPM_NAME Not Installed");
		} elsif ( $RPM_COMPARISON > 2 ) {
			SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Multiple Versions of $RPM_NAME RPM are Installed");
		} else {
			if ( $RPM_COMPARISON == 0 ) {
				if ( autofsFailureConfirmed() ) {
					SDP::Core::updateStatus(STATUS_CRITICAL, "Automounter krb5_cc_get_principal observed");
				} else {
					SDP::Core::updateStatus(STATUS_WARNING, "Automounter may fail to start");
				}
			} else {
				SDP::Core::updateStatus(STATUS_ERROR, "Automounter start failure NOT observed");
			}                       
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Outside kernel/architecture Scope, skipping autofs test.");
	}
SDP::Core::printPatternResults();

exit;

