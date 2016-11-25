# modules/koji_helpers/manifests/regen_repos.pp
#
# == Class: koji_helpers::regen_repos
#
# Manages the regeneration of Koji's repository meta-data that's needed for
# proper buildroot population.  Such regeneration is necessary whenever the
# external repositories change, such as may happen with mirror
# synchronization.
#
# === Parameters
#
# ==== Required
#
# [*ext_repo_root*]
#   Name of the directory under which all external repositories reside.
#   Ideally, this is the longest path possible without getting specific about
#   any particular distribution release.
#
# ==== Optional
#
# [*enable*]
#   Instance is to be started at boot.  Either true (default) or false.
#
# [*ensure*]
#   Instance is to be 'running' (default) or 'stopped'.
#
# [*rest_secs*]
#   The number seconds to rest after all of Koji's internal repositories have
#   been regenerated and before the external repositories are checked again.
#   The default is 1,800 seconds (30 minutes).
#
# [*wait_repo*]
#   The maximum number of minutes to wait for Koji to finish its internal
#   repository regeneration.  Expiration does not kill the job, but does allow
#   job concurrency.  When set high, this can be used to avoid high loads from
#   concurrent jobs.  When set low, job concurrency is permitted.
#   The default is 120 minutes (2 hours).
#
# === See Also
#
#   Define[koji_helpers::buildroot_dependency]
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2016 John Florian


class koji_helpers::regen_repos (
        String[1] $ext_repo_root,
        Boolean $enable=true,
        Variant[Boolean, Enum['running', 'stopped']] $ensure='running',
        Integer[0] $rest_secs=1800,
        Integer[0] $wait_repo=120,
    ) inherits ::koji_helpers::params {

    File {
        owner     => 'root',
        group     => 'root',
        mode      => '0644',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'etc_t',
        before    => Service[$::koji_helpers::params::regen_repos_service],
        notify    => Service[$::koji_helpers::params::regen_repos_service],
    }

    file {
        '/etc/koji-helpers/regen-repos.conf':
            content => template('koji_helpers/regen-repos.conf.erb'),
            ;
    }

    concat { $::koji_helpers::params::regen_repos_conf:
        ensure => 'present',
    }

    concat::fragment { 'repos-header':
        target  => $::koji_helpers::params::regen_repos_conf,
        content => template('koji_helpers/repos.conf.erb'),
        order   => '01',
    }

    service { $::koji_helpers::params::regen_repos_service:
        ensure     => $ensure,
        enable     => $enable,
        hasrestart => true,
        hasstatus  => true,
    }

}
