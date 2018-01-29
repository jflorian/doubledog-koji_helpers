# modules/koji_helpers/manifests/params.pp
#
# == Class: koji_helpers::params
#
# Parameters for the koji_helpers Puppet module.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2016-2018 John Florian


class koji_helpers::params {

    case $::operatingsystem {
        'CentOS': {

            $services = ['gojira', 'smashd']

        }

        default: {
            fail ("${title}: operating system '${::operatingsystem}' is not supported")
        }

    }

}
