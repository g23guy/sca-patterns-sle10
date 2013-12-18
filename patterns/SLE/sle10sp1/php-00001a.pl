#!/usr/bin/perl

# Title:       PHP Security Advisory SUSE-SA:2008:004
# Description: PHP was updated to fix remote code execution security issues, Severity 5 of 10.
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
	PROPERTY_NAME_COMPONENT."=PHP",
	PROPERTY_NAME_PATTERN_ID."=$PATTERN_ID",
	PROPERTY_NAME_PRIMARY_LINK."=META_LINK_Security",
	PROPERTY_NAME_OVERALL."=$GSTATUS",
	PROPERTY_NAME_OVERALL_INFO."=None",
	"META_LINK_Security=http://www.novell.com/linux/security/advisories/2008_04_php.html"
);

##############################################################################
# Main Program Execution
##############################################################################

SDP::Core::processOptions();
	my $CHECKING            = 'PHP';
	my $ADVISORY            = '5';
	my $TYPE                = 'Remote code execution';
	my @PKGS_TO_CHECK       = ();
	my $FIXED_VERSION       = '';

	if  ( SDP::SUSE::compareKernel(SLE9SP5) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE9');
		@PKGS_TO_CHECK       = qw(php4 pache-mod_php4 apache2-mod_php4 mod_php4 mod_php4-apache2 mod_php4-core mod_php4-servlet php4-bcmath php4-bz2 php4-calendar php4-ctype php4-curl php4-dba php4-dbase php4-devel php4-domxml php4-exif php4-fastcgi php4-filepro php4-ftp php4-gd php4-gettext php4-gmp php4-iconv php4-imap php4-ldap php4-mbstring php4-mcal php4-mcrypt php4-mhash php4-mime_magic php4-mysql php4-pear php4-pgsql php4-qtdom php4-readline php4-recode php4-servlet php4-session php4-shmop php4-snmp php4-sockets php4-swf php4-sysvsem php4-sysvshm php4-unixODBC php4-wddx php4-xslt php4-yp php4-zlib);
		$FIXED_VERSION       = '4.3.4-43.85';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} elsif ( SDP::SUSE::compareKernel(SLE10SP1) <= 0 ) {
		SDP::Core::printDebug('DISTRIBUTION', 'SLE10');
		@PKGS_TO_CHECK       = qw(php5 apache2-mod_php5 php5-bcmath php5-bz2 php5-calendar php5-ctype php5-curl php5-dba php5-dbase php5-devel php5-dom php5-exif php5-fastcgi php5-filepro php5-ftp php5-gd php5-gettext php5-gmp php5-iconv php5-imap php5-ldap php5-mbstring php5-mcrypt php5-mhash php5-mysql php5-mysqli php5-ncurses php5-odbc php5-openssl php5-pcntl php5-pdo php5-pear php5-pgsql php5-posix php5-pspell php5-shmop php5-snmp php5-soap php5-sockets php5-sqlite php5-suhosin php5-sysvmsg php5-sysvsem php5-sysvshm php5-tokenizer php5-wddx php5-xmlreader php5-xmlrpc php5-xsl php5-zlib);
		$FIXED_VERSION       = '5.1.2-29.50';
		SDP::Core::printDebug('ARGS', "$CHECKING, $ADVISORY, $TYPE, $#PKGS_TO_CHECK, $FIXED_VERSION");
		SDP::SUSE::securitySeverityPackageCheck($CHECKING, $ADVISORY, $TYPE, \@PKGS_TO_CHECK, $FIXED_VERSION);
	} else {
		SDP::Core::printDebug('DISTRIBUTION', 'None Selected');
		SDP::Core::updateStatus(STATUS_ERROR, "ABORTED: $CHECKING Security Advisory: Outside the kernel scope");
	}

SDP::Core::printPatternResults();

exit;
