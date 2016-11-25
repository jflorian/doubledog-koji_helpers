# modules/koji_helpers/manifests/init.pp
#
# == Class: koji_helpers
#
# Manages koji-helpers on a host.
#
# === Parameters
#
# ==== Required
#
# [*repo_dir*]
#   Name of the directory that is to be synchronized with the repository tree
#   composited from each of the mashed repositories.  This typically would be
#   the longest path that all package repositories have in common.
#
# [*repo_owner*]
#   User to own the "repo_dir" and the content therein.
#
# ==== Optional
#
# [*check_interval*]
#   The (minimum) number of seconds that smashd is to wait between checks for
#   new tag events.  The default is 10 seconds.
#
# [*quiescent_period*]
#   The number of seconds that must pass without any more new tag events
#   before smashd will initiate the signing/mashing process.  The default is
#   30 seconds.
#
# [*exclude_tags*]
#   An array of tags which smashd should ignore.  The default is ['trashcan'].
#
# [*enable*]
#   Services are to be started at boot.  Either true (default) or false.
#
# [*ensure*]
#   Services are to be 'running' (default) or 'stopped'.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2016 John Florian


class koji_helpers (
        String[1] $repo_dir,
        String[1] $repo_owner,
        Numeric $check_interval=10,
        Boolean $enable=true,
        Variant[Boolean, Enum['running', 'stopped']] $ensure='running',
        Array $exclude_tags=['trashcan'],
        Numeric $quiescent_period=30,
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
