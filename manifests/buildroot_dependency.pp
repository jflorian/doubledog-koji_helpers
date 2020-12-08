#
# == Define: koji_helpers::buildroot_dependency
#
# Manages a buildroot's dependencies on external package repositories.
#
# If a Koji buildroot has dependencies on external package repositories,
# builds within that buildroot will fail if those external package
# repositories mutate unless Koji's internal repository meta-data is
# regenerated.  This definition allows you to declare such dependencies so
# that such regeneration will be performed automatically, as needed.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-koji_helpers Puppet module.
# Copyright 2016-2020 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


define koji_helpers::buildroot_dependency (
        Array[String[1]]        $arches,
        Array[String[1]]        $ext_repo_urls,
        Ddolib::File::Ensure    $ensure='present',
        String[1]               $buildroot_name=$title,
    ) {

    if $ensure == 'present' or $ensure == true {
        concat::fragment { "koji-helper buildroot_dependency ${buildroot_name}":
            target  => $koji_helpers::config,
            content => template('koji_helpers/config-buildroot-dep.erb'),
            order   => '03',
        }
    }

}
