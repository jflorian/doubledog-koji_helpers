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
# This file is part of the doubledog-koji_helpers Puppet module.
# Copyright 2016-2020 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


define koji_helpers::repo (
        Koji_helpers::Gpgkeyid  $gpg_key_id,
        String[1]               $sigul_key_name,
        String[1]               $sigul_key_pass,
        Array                   $arches=['i386', 'x86_64'],
        Ddolib::File::Ensure    $ensure='present',
        String                  $repo_name=$title,
    ) {

    if $ensure == 'present' or $ensure == true {
        concat::fragment { "koji-helper repository ${repo_name}":
            target  => $koji_helpers::config,
            content => template('koji_helpers/config-repo.erb'),
            order   => '02',
        }
    }

}
