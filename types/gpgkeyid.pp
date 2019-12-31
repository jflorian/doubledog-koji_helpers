#
# == Type: Koji_helpers::Gpgkeyid
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-koji_helpers Puppet module.
# Copyright 2019 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


type Koji_helpers::Gpgkeyid = Variant[
    Pattern[/\h{8}/],
    Pattern[/\h{16}/],
    Pattern[/\h{40}/],
]
