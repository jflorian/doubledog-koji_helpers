<!--
# This file is part of the doubledog-koji_helpers Puppet module.
# Copyright 2018-2019 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later
-->

# koji\_helpers

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with koji\_helpers](#setup)
    * [What koji\_helpers affects](#what-koji\_helpers-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with koji\_helpers](#beginning-with-koji\_helpers)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
    * [Defined types](#defined-types)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module lets you manage the koji-helpers package and its configuration.  That package, however, has not yet been released to the general public so this is not likely to be of any value to you.  Sorry kids.

## Setup

### What koji\_helpers Affects

### Setup Requirements

### Beginning with koji\_helpers

## Usage

## Reference

**Classes:**

* [koji\_helpers](#koji\_helpers-class)

**Defined types:**

* [koji\_helpers::buildroot\_dependency](#koji\_helpersbuildroot\_dependency-defined-type)
* [koji\_helpers::repo](#koji\_helpersrepo-defined-type)


### Classes

#### koji\_helpers class

This class manages the package installation, the work directory along with the gojira and smashd services.  It also anchors the various configuration fragments that govern those services.

##### `notifications_from` (required)
The email address to be used as the sender when smashd sends notifications.

##### `notifications_to` (required)
An array of email address that are to be notified when smashd affects package repositories.

##### `repo_dir` (required)
Name of the directory that is to be synchronized with the repository tree composited from each of the mashed repositories.  This typically would be the longest path that all package repositories have in common.

##### `repo_owner` (required)
User that is to own the *repo_dir* and the content therein.

##### `config`
The filename of the main koji-helpers configuration file.  The default should be correct for supported platforms.

##### `exclude_tags`
An array of tags which smashd should ignore.  The default is `['trashcan']`.

##### `enable`
Services are to be started at boot.  Either `true` (default) or `false`.

##### `ensure`
Services are to be `'running'` (default) or `'stopped'`.  Alternatively, a Boolean value may also be used with `true` equivalent to `'running'` and `false` equivalent to `'stopped'`.

##### `mash_conf_dir`
The name of the directory where the mash configurations are kept.  The default should be correct for supported platforms.

##### `mash_work_dir`
The name of the directory where the mash is to perform its work.  The default should be correct for supported platforms.

##### `min_interval`, `max_interval`
These serve as an enforced range boundary for both the check-interval and quiescence-period, both of which are auto-tuned.  The *min_interval* helps avoid abusing your Koji Hub while the *max_interval* helps ensure you don't wait too long for repository updates.  The defaults are those from the application.

##### `packages`
An array of package names needed for the koji-helpers installation.  The default should be correct for supported platforms.

##### `repos`
A hash whose keys are repository configuration resource names and whose values are hashes comprising the same parameters you would otherwise pass to the [koji\_helpers::repo](#koji\_helpersrepo-defined-type) defined type.  The default is none.

##### `services`
An array of services names needed for the operation of koji-helpers.  The default should be correct for supported platforms.


### Defined types

#### koji\_helpers::buildroot\_dependency defined type

This defined type manages Gojira's configuration for a buildroot's dependencies on external package repositories.

If a Koji buildroot has dependencies on external package repositories, builds within that buildroot will fail if those external package repositories mutate unless Koji's internal repository meta-data is regenerated.  This definition allows you to declare such dependencies so that such regeneration will be triggered by Gojira automatically, as needed.

##### `namevar` (required)
An arbitrary identifier for the buildroot dependency instance unless the *buildroot_name* parameter is not set in which case this must provide the value normally set with the *buildroot_name* parameter.

##### `ext_repo_urls` (required)
An array of URLs referencing external package repositories upon which this buildroot is dependent.  These entries need not match your package manager's configuration for repositories on a one-to-one basis.  If anything changes in one of these package repositories, the regeneration will be triggered.

For a hint of what belongs here, consult the output of: `koji list-external-repos`

##### `ensure`
Instance is to be `'present'` (default) or `'absent'`.

##### `buildroot_name`
This may be used in place of *namevar* if it's beneficial to give *namevar* an arbitrary value.  If set, this must provide the Koji tag representing the buildroot having external dependencies.


#### koji\_helpers::repo defined type

This defined type manages Smashd's configuration for a package repository.

##### `namevar` (required)
An arbitrary identifier for the mash repository instance unless the *repo_name* parameter is not set in which case this must provide the value normally set with the *repo_name* parameter.

##### `dist_tag` (required)
Pull RPMs from what Koji tag?

##### `gpg_key_id` (required)
A string providing the GPG key ID of *sigul_key_name*.  E.g., `'4F2A6FD2'`.

##### `sigul_key_name` (required)
The key name that smashd is to direct Sigul to use to sign packages in this repository.  E.g., `'centos_7'`

##### `sigul_key_pass` (required)
The passphrase that Sigul will require to unlock *sigul_key_name*.

##### `ensure`
Instance is to be `'present'` (default) or `'absent'`.

##### `arches`
An array of the platform architectures to be included in the repository.  Defaults to `['i386', 'x86_64']`.

##### `debug_info`
If `true`, the debug-info files will be copied into the mashed repository; otherwise they will be skipped.

##### `debug_info_path`
Directory name where the debug RPMs are to land.  The default is a dynamic value that matches the package architecture and is relative to the directory named *repo_name* which itself is relative to the *repo_dir* specified for the `koji_helpers` class.

##### `delta`
Should delta-RPMs be produced for the repository?  Defaults to `false`.

##### `distro_tags`
Undocumented.  Defaults to `"cpe:/o:fedoraproject:fedora:$repo_name Null"`.

##### `hash_packages`
If `true`, each RPM will be placed within a subdirectory whose name matches the first character of the RPM.  Otherwise such subdirectories will not be used.  Defaults to `true`.

##### `inherit`
Undocumented.  Defaults to `false`.

##### `latest`
If `true`, only include the latest version of each package in the tag.  If `false`, include all versions in the tag.  This may also be set to an integer for a middle ground of this many, at most, of the latest versions.  Thus, values of `true` and `1` are equivalent as are `false` and infinity (if Puppet were to have such a value).  The specific meaning of latest version here matches normal rpm behavior, i.e., epoch > version > release.  Defaults to `true`.

##### `mash_gpg_key_ids`
An array of strings providing the GPG key IDs that are permitted in the resultant repository.  This is only relevant when *strict_keys* is `true` and is ignored otherwise.  Defaults to `[$gpg_key_id]`.

##### `mash_path`
Name of the directory into which this repository is to be mashed by smashd.  Defaults to the value set by *repo_name*.

##### `max_delta_rpm_age`
Skip the delta-RPM for any package where the base package is more than this many seconds old.   Defaults to `'604800'` (== 7 days).

##### `max_delta_rpm_size`
Skip the delta-RPM for any package where the size would exceed this value.  Defaults to `800000000` (== 800 MB).

##### `multilib`
If `true`, binary RPMs for various target hardware platforms will be combined; otherwise they will be kept separate.

##### `multilib_method`
Undocumented.  Defaults to `"devel"`.

##### `repo_name`
This may be used in place of *namevar* if it's beneficial to give namevar an arbitrary value.

##### `repodata_path`
Directory name where the repodata files are to land.  The default is a dynamic value that matches the package architecture and is relative to the directory named *repo_name* which itself is relative to the *repo_dir* specified for the `koji_helpers` class.

##### `repoview_title`
Title to be used atop the repoview pages.

##### `repoview_url`
Repository URL to use when generating the RSS feed.  The default disables RSS feed generation.

##### `rpm_path`
Directory name where the binary RPMs are to land.  The default is a dynamic value that matches the package architecture and is relative to the directory named *repo_name* which itself is relative to the *repo_dir* specified for the `koji_helpers` class.

##### `source_path`
Directory name where the source RPMs are to land.  The default is `'SRPMS'` and is relative to the directory named *repo_name* which itself is relative to the *repo_dir* specified for the `koji_helpers` class.

##### `strict_keys`
If `true`, the mashing will intentionally fail if any of the builds has not be signed with one of the GPG keys listed in *mash_gpg_key_ids*.  Defaults to `false`.


## Limitations

Tested on modern CentOS releases, but likely to work on any Red Hat variant.  Adaptations for other operating systems should be trivial as this module follows the data-in-module paradigm.  See `data/common.yaml` for the most likely obstructions.  If "one size can't fit all", the value should be moved from `data/common.yaml` to `data/os/%{facts.os.name}.yaml` instead.  See `hiera.yaml` for how this is handled.

This should be compatible with Puppet 4.x.

## Development

Contributions are welcome via pull requests.  All code should generally be compliant with puppet-lint.
