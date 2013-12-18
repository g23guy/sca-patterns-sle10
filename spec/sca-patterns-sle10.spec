#
# spec file for package scdiag (Version 1.1)
#
# Copyright (C) 2013 SUSE LLC
# This file and all modifications and additions to the pristine
# package are under the same license as the package itself.
#

# norootforbuild
# neededforbuild

%define produser sca
%define prodgrp sdp
%define patuser root
%define patgrp root
%define patdir /var/opt/%{produser}/patterns

Name:         sca-patterns-sle10
Summary:      Supportconfig Analysis Patterns for SLE10
Group:        Documentation/SuSE
Distribution: SUSE Linux Enterprise
Vendor:       SUSE Support
License:      GPLv2
Autoreqprov:  on
Version:      1.1
Release:      1
Source:       %{name}-%{version}.tar.gz
BuildRoot:    %{_tmppath}/%{name}-%{version}
Buildarch:    noarch
Requires:     sca-patterns-base
%description
Supportconfig Analysis (SCA) appliance patterns to identify known
issues relating to all versions of SLES/SLED 10

Authors:
--------
    Jason Record <jrecord@suse.com>

%files
%defattr(-,%{patuser},%{patgrp})
%dir /var/opt/%{produser}
%dir %{patdir}
%dir %{patdir}/SLE
%dir %{patdir}/SLE/sle10all
%dir %{patdir}/SLE/sle10sp0
%dir %{patdir}/SLE/sle10sp1
%dir %{patdir}/SLE/sle10sp2
%dir %{patdir}/SLE/sle10sp3
%dir %{patdir}/SLE/sle10sp4
%attr(555,%{patuser},%{patgrp}) %{patdir}/SLE/sle10all/*
%attr(555,%{patuser},%{patgrp}) %{patdir}/SLE/sle10sp0/*
%attr(555,%{patuser},%{patgrp}) %{patdir}/SLE/sle10sp1/*
%attr(555,%{patuser},%{patgrp}) %{patdir}/SLE/sle10sp2/*
%attr(555,%{patuser},%{patgrp}) %{patdir}/SLE/sle10sp3/*
%attr(555,%{patuser},%{patgrp}) %{patdir}/SLE/sle10sp4/*

%prep
%setup -q

%build
make build

%install
make install

%changelog
* Wed Dec 18 2013 jrecord@suse.com
- separated as individual RPM package
- added
  firefox-SUSE-SU-2013_1678-1d.pl sle10sp4
  firefox-SUSE-SU-2013_1678-1e.pl sle10sp3
  java-SUSE-SU-2013_1677-23.pl sle10sp3
  java-SUSE-SU-2013_1677-2d.pl sle10sp4
  javaibm-SUSE-SU-2013_1669-1a.pl sle10sp4
  javaibm-SUSE-SU-2013_1669-1b.pl sle10sp3

