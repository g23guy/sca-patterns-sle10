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
%define mode 544
%define category SLE

Name:         sca-patterns-sle10
Summary:      Supportconfig Analysis Patterns for SLE10
URL:          https://bitbucket.org/g23guy/sca-patterns-sle10
Group:        Documentation/SuSE
Distribution: SUSE Linux Enterprise
Vendor:       SUSE Support
License:      GPL-2.0
Autoreqprov:  on
Version:      1.2
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

%prep
%setup -q

%build

%install
pwd;ls -la
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/%{patdir}/%{category}
install -d $RPM_BUILD_ROOT/%{patdir}/%{category}/sle10all
install -d $RPM_BUILD_ROOT/%{patdir}/%{category}/sle10sp0
install -d $RPM_BUILD_ROOT/%{patdir}/%{category}/sle10sp1
install -d $RPM_BUILD_ROOT/%{patdir}/%{category}/sle10sp2
install -d $RPM_BUILD_ROOT/%{patdir}/%{category}/sle10sp3
install -d $RPM_BUILD_ROOT/%{patdir}/%{category}/sle10sp4
install -m %{mode} patterns/%{category}/sle10all/* $RPM_BUILD_ROOT/%{patdir}/%{category}/sle10all
install -m %{mode} patterns/%{category}/sle10sp0/* $RPM_BUILD_ROOT/%{patdir}/%{category}/sle10sp0
install -m %{mode} patterns/%{category}/sle10sp1/* $RPM_BUILD_ROOT/%{patdir}/%{category}/sle10sp1
install -m %{mode} patterns/%{category}/sle10sp2/* $RPM_BUILD_ROOT/%{patdir}/%{category}/sle10sp2
install -m %{mode} patterns/%{category}/sle10sp3/* $RPM_BUILD_ROOT/%{patdir}/%{category}/sle10sp3
install -m %{mode} patterns/%{category}/sle10sp4/* $RPM_BUILD_ROOT/%{patdir}/%{category}/sle10sp4

%files
%defattr(-,%{patuser},%{patgrp})
%dir /var/opt/%{produser}
%dir %{patdir}
%dir %{patdir}/%{category}
%dir %{patdir}/%{category}/sle10all
%dir %{patdir}/%{category}/sle10sp0
%dir %{patdir}/%{category}/sle10sp1
%dir %{patdir}/%{category}/sle10sp2
%dir %{patdir}/%{category}/sle10sp3
%dir %{patdir}/%{category}/sle10sp4
%attr(%{mode},%{patuser},%{patgrp}) %{patdir}/%{category}/sle10all/*
%attr(%{mode},%{patuser},%{patgrp}) %{patdir}/%{category}/sle10sp0/*
%attr(%{mode},%{patuser},%{patgrp}) %{patdir}/%{category}/sle10sp1/*
%attr(%{mode},%{patuser},%{patgrp}) %{patdir}/%{category}/sle10sp2/*
%attr(%{mode},%{patuser},%{patgrp}) %{patdir}/%{category}/sle10sp3/*
%attr(%{mode},%{patuser},%{patgrp}) %{patdir}/%{category}/sle10sp4/*

%clean
rm -rf $RPM_BUILD_ROOT

%changelog
* Wed Dec 20 2013 jrecord@suse.com
- separated as individual RPM package
- added
  firefox-SUSE-SU-2013_1678-1d.pl sle10sp4
  firefox-SUSE-SU-2013_1678-1e.pl sle10sp3
  java-SUSE-SU-2013_1677-23.pl sle10sp3
  java-SUSE-SU-2013_1677-2d.pl sle10sp4
  javaibm-SUSE-SU-2013_1669-1a.pl sle10sp4
  javaibm-SUSE-SU-2013_1669-1b.pl sle10sp3

