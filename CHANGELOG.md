<!--
This file is part of the doubledog-koji_helpers Puppet module.
Copyright 2018-2019 John Florian
SPDX-License-Identifier: GPL-3.0-or-later

Template

## [VERSION] WIP
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

-->

# Change log

All notable changes to this project (since v1.2.0) will be documented in this file.  The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and this project adheres to [Semantic Versioning](http://semver.org).

## [2.1.0] 2019-12-31
### Added
- `Koji_helpers::Gpgkeyid` data type
### Changed
- `koji_helpers::repo::gpg_key_id` now accepts long and full IDs in addition to short ones
### Fixed
- `koji_helpers::repo::gpg_key_id` accepted non-hex digits
- `koji_helpers::repo::gpg_key_id` would not accept long or full IDs

## [2.0.0] 2019-06-13
### Added
- management for the new `klean` tool/service/timer
### Removed
- management of any `mash` configuration files
- all parameters and resources related to executing `mash` or its output
### Fixed
- config pathname comment may not reflect actuality

## [1.5.0] 2019-06-05
### Added
- Puppet 6 compatibility
- new parameters to main `koji_helpers` class to allow Hiera-driven deployment:
    - `buildroot_dependencies`
    - `repos`
### Changed
- `validate_absolute_path()` function to `Stdlib::Absolutepath` data type
### Removed
- `koji_helper::notifications_from` default value

## [1.4.0] 2019-05-02
### Changed
- dependency on `doubledog/ddolib` now expects 1 >= version < 2
- Absolute namespace references have been eliminated since modern Puppet versions no longer require this.

## [1.3.0] 2018-12-16
### Changed
- puppetlabs-concat dependency now allows version 5
- puppetlabs-stdlib dependency now allows version 5

## [1.2.0 and prior] 2018-12-15

This and prior releases predate this project's keeping of a formal CHANGELOG.  If you are truly curious, see the Git history.
