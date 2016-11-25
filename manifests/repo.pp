# modules/koji_helpers/manifests/repo.pp
#
# == Define: koji_helpers::repo
#
# Manages a repository configuration for koji-helpers.
#
# === Parameters
#
# ==== Required
#
# [*namevar*]
#   An arbitrary identifier for the mash repository instance unless the
#   "repo_name" parameter is not set in which case this must provide the value
#   normally set with the "repo_name" parameter.
#
# [*dist_tag*]
#   Pull RPMs from what Koji tag?
#
# [*gpg_key_id*]
#   The GPG key ID of "sigul_key_name".  E.g., '4F2A6FD2'.
#
# [*sigul_key_name*]
#   The key name that smashd is to direct Sigul to use to sign packages in
#   this repository.  E.g., 'centos_7'
#
# [*sigul_key_pass*]
#   The passphrase that Sigul will require to unlock "sigul_key_name".
#
# ==== Optional
#
# [*ensure*]
#   Instance is to be 'present' (default) or 'absent'.
#
# [*arches*]
#   A list of the platform architectures to be included in the repository.
#   Defaults to ['i386', 'x86_64'].
#
# [*debug_info*]
#   If true, the debug-info files will be copied into the mashed repository;
#   otherwise they will be skipped.
#
# [*debug_info_path*]
#   Directory name where the debug RPMs are to land.  The default is a dynamic
#   value that matches the package architecture and is relative to the
#   directory named "repo_name" which itself is relative to the "repo_dir"
#   specified for Class[koji_helpers].
#
# [*delta*]
#   Should delta-RPMs be produced for the repository?  Defaults to false.
#
# [*distro_tags*]
#   Undocumented.  Defaults to "cpe:/o:fedoraproject:fedora:$repo_name Null".
#
# [*hash_packages*]
#   If true, each RPM will be placed within a subdirectory whose name matches
#   the first character of the RPM.  Otherwise such subdirectories will not be
#   used.  Defaults to true.
#
# [*inherit*]
#   Undocumented.  Defaults to false.
#
# [*mash_path*]
#   Name of the directory into which this repository is to be mashed by
#   smashd.  Defaults to the value set by "repo_name".
#
# [*max_delta_rpm_age*]
#   Skip the delta-RPM for any package where the base package is more than
#   this many seconds old.   Defaults to 604,800 (== 7 days).
#
# [*max_delta_rpm_size*]
#   Skip the delta-RPM for any package where the size would exceed this value.
#   Defaults to 800,000,000.
#
# [*multilib*]
#   If true, binary RPMs for various target hardware platforms will be
#   combined; otherwise they will be kept separate.
#
# [*multilib_method*]
#   Undocumented.  Defaults to "devel".
#
# [*repo_name*]
#   This may be used in place of "namevar" if it's beneficial to give namevar
#   an arbitrary value.
#
# [*repodata_path*]
#   Directory name where the repodata files are to land.  The default is
#   a dynamic value that matches the package architecture and is relative to
#   the directory named "repo_name" which itself is relative to the "repo_dir"
#   specified for Class[koji_helpers].
#
# [*repoview_title*]
#   Title to be used atop the repoview pages.
#
# [*repoview_url*]
#   Repository URL to use when generating the RSS feed.  The default disables
#   RSS feed generation.
#
# [*rpm_path*]
#   Directory name where the binary RPMs are to land.  The default is
#   a dynamic value that matches the package architecture and is relative to
#   the directory named "repo_name" which itself is relative to the "repo_dir"
#   specified for Class[koji_helpers].
#
# [*source_path*]
#   Directory name where the source RPMs are to land.  The default is
#   "SRPMS" and is relative to the directory named "repo_name" which itself is
#   relative to the "repo_dir" specified for Class[koji_helpers].
#
# [*strict_keys*]
#   If true, the mashing will intentionally fail if any of the builds has not
#   be signed with the "gpg_key_id".  Defaults to false.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2016 John Florian


define koji_helpers::repo (
        String[1] $dist_tag,
        String[8, 8] $gpg_key_id,
        String[1] $sigul_key_name,
        String[1] $sigul_key_pass,
        Variant[Boolean, Enum['present', 'absent']] $ensure='present',
        Array $arches=['i386', 'x86_64'],
        Boolean $debug_info=true,
        String $debug_info_path='%(arch)s/debug',
        Boolean $delta=false,
        Variant[Undef, String[1]] $distro_tags=undef,
        Boolean $hash_packages=true,
        Boolean $inherit=false,
        Variant[Undef, String[1]] $mash_path=undef,
        Integer $max_delta_rpm_age=604800,
        Integer $max_delta_rpm_size=800000000,
        Boolean $multilib=false,
        String $multilib_method='devel',
        String $repo_name=$title,
        String $repodata_path='%(arch)s',
        String $repoview_title="Packages from ${dist_tag} for %(arch)s",
        String $repoview_url=undef,
        String $rpm_path='%(arch)s',
        String $source_path='SRPMS',
        Boolean $strict_keys=false,
    ) {

    include '::koji_helpers::params'

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

    file { "${::koji_helpers::params::mash_conf_dir}/${repo_name}.mash":
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
            target  => $::koji_helpers::params::config,
            content => template('koji_helpers/config-repo.erb'),
            order   => '02',
        }
    }

}
