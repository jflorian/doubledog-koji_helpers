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
        String[1]               $config,
        String[1]               $mash_work_dir,
        Array[String[1], 1]     $packages,
        Array[String[1], 1]     $services,
        Stdlib::Absolutepath    $repo_dir,
        String[1]               $repo_owner,
        Array[String[1]]        $notifications_to,
        Boolean                 $enable,
        Ddolib::Service::Ensure $ensure,
        Array[String[1]]        $exclude_tags,
        String[1]               $notifications_from,
        Optional[Integer[0]]    $min_interval,
        Optional[Integer[0]]    $max_interval,
        Hash[String[1], Hash]   $buildroot_dependencies,
        Hash[String[1], Hash]   $repos,
    ) {

    package { $packages:
        ensure => installed,
        notify => Service[$services],
    }

    -> file { $koji_helpers::mash_work_dir:
        ensure  => directory,
        owner   => $repo_owner,
        group   => $repo_owner,
        mode    => '0755',
        seluser => 'system_u',
        selrole => 'object_r',
        seltype => 'var_t',
    }

    -> concat { $config:
        owner     => $repo_owner,
        group     => $repo_owner,
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
