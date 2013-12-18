#!/usr/bin/perl

# Title:       Fully virtualized Xen DomU crashes upon incoming network
# Description: If a fully virtualized DomainU has 4 GB or more of RAM and is using the paravirtual network drivers, some types of network traffic may cause a kernel oops.
# Modified:    2013 Jun 28
# SLE10 SP2

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
	PROPERTY_NAME_CATEGORY."=Xen",
	PROPERTY_NAME_COMPONENT."=Network",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_TID",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_TID=http://www.suse.com/support/kb/doc.php?id=7003241",
	"META_LINK_BUG=https://bugzilla.novell.com/show_bug.cgi?id=496789"
);

##############################################################################
# Local Function Definitions
##############################################################################

sub xenFullVirtual {
	SDP::Core::printDebug('> xenFullVirtual', 'START');
	my $HEADER_LINES             = 0;
	my $RCODE                    = -1;
	my $FILE_OPEN                = 'basic-environment.txt';
	my $SECTION                  = 'Virtualization';
	my @CONTENT                  = ();
	my @LINE_CONTENT             = ();
	my $LINE                     = 0;

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( $LINE++ < $HEADER_LINES ); # Skip header lines
			next if ( /^\s*$/ );                    # Skip blank lines
			if ( /^Type:/ ) {
				SDP::Core::printDebug("LINE $LINE", $_);
				@LINE_CONTENT = split(/:\s+/, $_);
				if ( $LINE_CONTENT[1] =~ 'Fully Virtualized' ) {
					$RCODE = 1;
				} else {
					$RCODE = 0;
				}
				last;
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	SDP::Core::printDebug("< xenFullVirtual", "Returns: $RCODE");
	return $RCODE;
}

sub systemInfo {
	SDP::Core::printDebug('> systemInfo', 'START');
	my %SYSINFO                  = (
		MemTotal => 0,
		MemFree => 0,
	);
	my $FILE_OPEN                = 'memory.txt';
	my $SECTION                  = '/proc/meminfo';
	my @CONTENT                  = ();
	my @LINE_CONTENT             = ();
	my $LINE                     = 0;

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( /^\s*$/ );                    # Skip blank lines
			$LINE++;
			if ( /^MemTotal:/ ) {
				SDP::Core::printDebug("LINE $LINE", $_);
				@LINE_CONTENT = split(/\s+/, $_);
				$SYSINFO{'MemTotal'} = $LINE_CONTENT[1];
			}
			if ( /^MemFree:/ ) {
				SDP::Core::printDebug("LINE $LINE", $_);
				@LINE_CONTENT = split(/\s+/, $_);
				$SYSINFO{'MemFree'} = $LINE_CONTENT[1];
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	if ( $OPT_LOGLEVEL >= LOGLEVEL_DEBUG ) {
		my $key;
		my $value;
		print(' %SYSINFO                       = ');
		while ( ($key, $value) = each(%SYSINFO) ) {
			print("$key => \"$value\"  ");
		}
		print("\n");
	}

	SDP::Core::printDebug("< systemInfo", "Returns: \%SYSINFO, $SYSINFO{'MemTotal'}");
	return %SYSINFO;
}

sub xenNetPVDrivers {
	SDP::Core::printDebug('> xenNetPVDrivers', 'START');
	my $RCODE                    = 0;
	my %XEN_PV_DRIVER = SDP::SUSE::getDriverInfo('xen_vnif');
	$RCODE = 1 if ( $XEN_PV_DRIVER{'loaded'} );
	SDP::Core::printDebug("< xenNetPVDrivers", "Returns: $RCODE");
	return $RCODE;
}

sub kernelOopsFound {
	SDP::Core::printDebug('> kernelOopsFound', 'START');
	my $RCODE                    = 0;
	my $FILE_OPEN                = 'messages.txt';
	my $SECTION                  = '/var/log/messages';
	my @CONTENT                  = ();
	my $LINE                     = 0;

	if ( SDP::Core::getSection($FILE_OPEN, $SECTION, \@CONTENT) ) {
		foreach $_ (@CONTENT) {
			next if ( /^\s*$/ );                    # Skip blank lines
			$LINE++;
			if ( /Kernel panic.*killing interrupt handler/i ) {
				SDP::Core::printDebug("LINE $LINE", $_);
				$RCODE++;
				last;
			}
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "Cannot find \"$SECTION\" section in $FILE_OPEN");
	}
	SDP::Core::printDebug("< kernelOopsFound", "Returns: $RCODE");
	return $RCODE;
}

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	if ( xenFullVirtual() > 0 ) {
		SDP::Core::updateStatus(STATUS_PARTIAL, "Xen Full Virtual VM Detected");
		if ( compareKernel('2.6.16.60-0.39.3') < 0 ) {
			SDP::Core::updateStatus(STATUS_PARTIAL, "Full Virtual VM within the Kernel Scope");
			my %SYSTEM_INFO = systemInfo();
			if ( $SYSTEM_INFO{'MemTotal'} >= 3900000 ) {
				SDP::Core::updateStatus(STATUS_PARTIAL, "4GB or more of RAM found");
				if ( xenNetPVDrivers() ) {
					SDP::Core::updateStatus(STATUS_PARTIAL, "Xen Paravirtual Network Drivers detected");
					SDP::Core::updateStatus(STATUS_WARNING, "System may be suseptible to kernel crash from network traffic");
				} else {
					SDP::Core::updateStatus(STATUS_ERROR, "No Xen Paravirtual Network Drivers detected");
				}
			} else {
				SDP::Core::updateStatus(STATUS_ERROR, "ABORT: Server has less than 4G of RAM");
			}
		} else {
			SDP::Core::updateStatus(STATUS_ERROR, "ABORT: Full Virtual VM Outside the Kernel Scope");
		}
	} else {
		SDP::Core::updateStatus(STATUS_ERROR, "ABORT: Server is not Xen Full Virtual VM");
	}
SDP::Core::printPatternResults();

exit;

