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
# Copyright 2016-2018 John Florian


define koji_helpers::buildroot_dependency (
        Array[String[1]]        $arches,
        Array[String[1]]        $ext_repo_urls,
        Variant[Boolean, Enum['present', 'absent']] $ensure='present',
        String[1]               $buildroot_name=$title,
    ) {

    if $ensure == 'present' {
        concat::fragment { "koji-helper buildroot_dependency ${buildroot_name}":
            target  => $::koji_helpers::config,
            content => template('koji_helpers/config-buildroot-dep.erb'),
            order   => '03',
        }
    }

}
