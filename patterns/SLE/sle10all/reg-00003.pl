#!/usr/bin/perl

# Title:       Cannot Register SLES10
# Description: SSL3_GET_SERVER_CERTIFICATE errors when attempting to register for online updates
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
	PROPERTY_NAME_COMPONENT."=Registration",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7010008"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub curlFails {
	SDP::Core::printDebug('> curlFails', 'BEGIN');
	my $RCODE = 0;
	my $FILE_OPEN = 'updates.txt';
	my $SECTION = '/usr/bin/curl.*secure-www';
	my @CONTENT = ();

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( m/^\s*$/ ); # Skip blank lines
			if ( /GET_SERVER_CERTIFICATE/ ) {
				$RCODE++;
				last;
			}
		}
	} else {
		$RCODE=-1;
	}
	SDP::Core::printDebug("< curlFails", "Returns: $RCODE");
	return $RCODE;
}

sub errorFound {
	SDP::Core::printDebug('> errorFound', 'BEGIN');
	my $RCODE = 0;
	my $FILE_OPEN = 'updates.txt';
	my $SECTION = 'grep -i suse_register';
	my @CONTENT = ();

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( m/^\s*$/ ); # Skip blank lines
			if ( /curl.*GET_SERVER_CERTIFICATE/ ) {
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

sub outdatedPackages {
	SDP::Core::printDebug('> outdatedPackages', 'BEGIN');
	my $RCODE = 0;
	my $RPM_NAME = 'openssl-certs';
	my $VERSION_TO_COMPARE = '0.8.0-0.10.1';
	my $RPM_COMPARISON = SDP::SUSE::compareRpm($RPM_NAME, $VERSION_TO_COMPARE);
	if ( $RPM_COMPARISON == 2 ) {
		$RCODE++;
	} elsif ( $RPM_COMPARISON > 2 ) {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Multiple Versions of $RPM_NAME RPM are Installed");
	} else {
		if ( $RPM_COMPARISON < 0 ) {
			$RCODE++;
		}			
	}

	$RPM_NAME = 'suseRegister';
	$VERSION_TO_COMPARE = '1.2-9.55.1';
	$RPM_COMPARISON = SDP::SUSE::compareRpm($RPM_NAME, $VERSION_TO_COMPARE);
	if ( $RPM_COMPARISON == 2 ) {
		$RCODE++;
	} elsif ( $RPM_COMPARISON > 2 ) {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Multiple Versions of $RPM_NAME RPM are Installed");
	} else {
		if ( $RPM_COMPARISON < 0 ) {
			$RCODE++;
		}			
	}
	SDP::Core::printDebug("< outdatedPackages", "Returns: $RCODE");
	return $RCODE;
}
##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $CURL_FAILURE = curlFails();
	if ( $CURL_FAILURE > 0 ) { # curl section found and failed on certificates
		if ( SDP::SUSE::compareKernel(SLE10SP4) >= 0 && SDP::SUSE::compareKernel(SLE10SP5) < 0 ) {
			if ( outdatedPackages() ) {
				SDP::Core::updateStatus(STATUS_CRITICAL, "Outdated certificate bundle packages, server registration will fail");
			} else {
				SDP::Core::updateStatus(STATUS_CRITICAL, "Consider reinstalling the certificate bundle packages");
			}
		} elsif ( SDP::SUSE::compareKernel(SLE10GA) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
			SDP::Core::updateStatus(STATUS_CRITICAL, "Outdated certificate bundle, server registration will fail");
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Outside kernel scope, skip certificate bundle test");
		}
	} elsif ( $CURL_FAILURE < 0 ) { # curl section not found
		if ( SDP::SUSE::compareKernel(SLE10SP4) >= 0 && SDP::SUSE::compareKernel(SLE10SP5) < 0 ) {
			if ( outdatedPackages() ) {
				if ( errorFound() ) {
					SDP::Core::updateStatus(STATUS_CRITICAL, "Outdated certificate bundle packages, server registration has failed");
				} else {
					SDP::Core::updateStatus(STATUS_CRITICAL, "Outdated certificate bundle packages, server registration will fail");
				}
			} else {
				if ( errorFound() ) {
					SDP::Core::updateStatus(STATUS_WARNING, "If server registration fails, consider reinstalling certificate bundle packages");
				} else {
					SDP::Core::updateStatus(STATUS_ERROR, "ERROR: No GET_SERVER_CERTIFICATE messages");
				}
			}
		} elsif ( SDP::SUSE::compareKernel(SLE10GA) >= 0 && SDP::SUSE::compareKernel(SLE10SP4) < 0 ) {
			if ( errorFound() ) {
				SDP::Core::updateStatus(STATUS_CRITICAL, "Outdated certificate bundle, server registration has failed");
			} else {
				SDP::Core::updateStatus(STATUS_ERROR, "ERROR: No GET_SERVER_CERTIFICATE messages");
			}
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "ERROR: Outside kernel scope, skip certificate bundle test");
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ERROR: curl works, nothing to check");
	}
SDP::Core::printPatternResults();

exit;


