#!/usr/bin/perl

# Title:       OpenOffice Security Advisory SUSE-SA:2008:023
# Description: OpenOffice was updated to local privilege escalation security issues, Severity 4 of 10.
# Modified:    2013 Jun 27

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
	PROPERTY_NAME_CLASS."=Security",
	PROPERTY_NAME_CATEGORY."=SLE",
	PROPERTY_NAME_COMPONENT."=OpenOffice",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_Security",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_Security=http://www.novell.com/linux/security/advisories/2008_23_openoffice.html"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $CHECKING            = 'OpenOffice';
	my $ADVISORY            = '4';
	my $TYPE                = 'Local privilege escalation';
	my @PKGS_TO_CHECK       = ();
	my $FIXED_VERSION       = '';

	if  ( SDP::SUSE::compareKernel(SLE9SP5) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE9');
		@PKGS_TO_CHECK       = qw(OpenOffice_org OpenOffice_org-ar OpenOffice_org-ca OpenOffice_org-cs OpenOffice_org-da OpenOffice_org-de OpenOffice_org-el OpenOffice_org-en OpenOffice_org-en-help OpenOffice_org-es OpenOffice_org-et OpenOffice_org-fi OpenOffice_org-fr OpenOffice_org-gnome OpenOffice_org-hu OpenOffice_org-it OpenOffice_org-ja OpenOffice_org-kde OpenOffice_org-ko OpenOffice_org-nl OpenOffice_org-pl OpenOffice_org-pt OpenOffice_org-pt-BR OpenOffice_org-ru OpenOffice_org-sk OpenOffice_org-sl OpenOffice_org-sv OpenOffice_org-tr OpenOffice_org-zh-CN OpenOffice_org-zh-TW);
		$FIXED_VERSION       = '1.1.5-0.22';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} elsif ( SDP::SUSE::compareKernel(SLE10SP1) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE10');
		@PKGS_TO_CHECK       = qw(OpenOffice_org OpenOffice_org-af OpenOffice_org-ar OpenOffice_org-ca OpenOffice_org-cs OpenOffice_org-da OpenOffice_org-de OpenOffice_org-es OpenOffice_org-fi OpenOffice_org-fr OpenOffice_org-galleries OpenOffice_org-gnome OpenOffice_org-gu-IN OpenOffice_org-hi-IN OpenOffice_org-hu OpenOffice_org-it OpenOffice_org-ja OpenOffice_org-kde OpenOffice_org-mono OpenOffice_org-nb OpenOffice_org-nl OpenOffice_org-nld OpenOffice_org-nn OpenOffice_org-pl OpenOffice_org-pt-BR OpenOffice_org-ru OpenOffice_org-sk OpenOffice_org-sv OpenOffice_org-xh OpenOffice_org-zh-CN OpenOffice_org-zh-TW OpenOffice_org-zu);
		$FIXED_VERSION       = '2.4-0.2.11';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} else {
		SDP::Core::printDebug('DISTRIBUTION', 'None Selected');
		SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: Outside the kernel scope");
	}

SDP::Core::printPatternResults();

exit;
