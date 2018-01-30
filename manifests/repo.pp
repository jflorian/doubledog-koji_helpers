#
# == Define: koji_helpers::repo
#
# Manages a repository configuration for koji-helpers.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2016-2018 John Florian


define koji_helpers::repo (
        String[1]               $dist_tag,
        String[8, 8]            $gpg_key_id,
        String[1]               $sigul_key_name,
        String[1]               $sigul_key_pass,
        Variant[Boolean, Enum['present', 'absent']] $ensure='present',
        Array                   $arches=['i386', 'x86_64'],
        Boolean                 $debug_info=true,
        String                  $debug_info_path='%(arch)s/debug',
        Boolean                 $delta=false,
        Variant[Undef, String[1]]       $distro_tags=undef,
        Boolean                 $hash_packages=true,
        Boolean                 $inherit=false,
        Variant[Boolean, Integer[1]]    $latest=true,
        Variant[Undef, String[1]]       $mash_path=undef,
        Integer                 $max_delta_rpm_age=604800,
        Integer                 $max_delta_rpm_size=800000000,
        Boolean                 $multilib=false,
        String                  $multilib_method='devel',
        String                  $repo_name=$title,
        String                  $repodata_path='%(arch)s',
        String                  $repoview_title="Packages from ${dist_tag} for %(arch)s",
        String                  $repoview_url=undef,
        String                  $rpm_path='%(arch)s',
        String                  $source_path='SRPMS',
        Boolean                 $strict_keys=false,
    ) {

    if $mash_path {
        $mash_path_ = $mash_path
    } else {
        $mash_path_ = $repo_name
    }

    if $distro_tags {
        $distro_tags_ = $distro_tags
    } else {
        $distro_tags_ = "cpe:/o:fedoraproject:fedora:${repo_name} Null"
    }

    file { "${::koji_helpers::mash_conf_dir}/${repo_name}.mash":
        ensure  => $ensure,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        seluser => 'system_u',
        selrole => 'object_r',
        seltype => 'etc_t',
        require => Class['koji_helpers'],
        content => template('koji_helpers/mash.erb'),
    }

    if $ensure == 'present' {
        concat::fragment { "koji-helper repository ${repo_name}":
            target  => $::koji_helpers::config,
            content => template('koji_helpers/config-repo.erb'),
            order   => '02',
        }
    }

}
