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
# Copyright 2016-2018 John Florian


class koji_helpers (
        String[1] $repo_dir,
        String[1] $repo_owner,
        Array[String[1]] $notifications_to,
        Boolean $enable=true,
        Variant[Boolean, Enum['running', 'stopped']] $ensure='running',
        Array[String[1]] $exclude_tags=['trashcan'],
        String[1] $notifications_from="${repo_owner}@${::domain}",
    ) inherits ::koji_helpers::params {

    validate_absolute_path($repo_dir)

    package { $::koji_helpers::params::packages:
        ensure => installed,
        notify => Service[$::koji_helpers::params::services],
    } ->

    file { $::koji_helpers::params::mash_work_dir:
        ensure  => directory,
        owner   => $repo_owner,
        group   => $repo_owner,
        mode    => '0755',
        seluser => 'system_u',
        selrole => 'object_r',
        seltype => 'var_t',
    } ->

    concat { $::koji_helpers::params::config:
        owner     => $repo_owner,
        group     => $repo_owner,
        mode      => '0600',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'etc_t',
        notify    => Service[$::koji_helpers::params::services],
        show_diff => false,
    }

    concat::fragment { 'config-header':
        target  => $::koji_helpers::params::config,
        content => template('koji_helpers/config-header.erb'),
        order   => '01',
    }

    service { $::koji_helpers::params::services:
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => true,
        hasstatus  => true,
    }

}
