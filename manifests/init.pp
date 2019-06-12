#
# == Class: koji_helpers
#
# Manages koji-helpers on a host.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-koji_helpers Puppet module.
# Copyright 2016-2019 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class koji_helpers (
        Hash[String[1], Hash]   $buildroot_dependencies,
        String[1]               $config,
        String[1]               $config_owner,
        Boolean                 $enable,
        Ddolib::Service::Ensure $ensure,
        Array[String[1]]        $exclude_tags,
        Optional[Integer[0]]    $max_interval,
        Optional[Integer[0]]    $min_interval,
        String[1]               $notifications_from,
        Array[String[1]]        $notifications_to,
        Array[String[1], 1]     $packages,
        Hash[String[1], Hash]   $repos,
        Array[String[1], 1]     $services,
    ) {

    package { $packages:
        ensure => installed,
        notify => Service[$services],
    }

    -> concat { $config:
        owner     => $config_owner,
        group     => $config_owner,
        mode      => '0600',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'etc_t',
        notify    => Service[$services],
        show_diff => false,
    }

    concat::fragment { 'config-header':
        target  => $config,
        content => template('koji_helpers/config-header.erb'),
        order   => '01',
    }

    service { $services:
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => true,
        hasstatus  => true,
    }

    create_resources(
        koji_helpers::buildroot_dependency,
        $buildroot_dependencies,
    )

    create_resources(koji_helpers::repo, $repos)

}
