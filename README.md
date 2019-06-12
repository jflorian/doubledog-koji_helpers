<!--
This file is part of the doubledog-koji_helpers Puppet module.
Copyright 2018-2019 John Florian
SPDX-License-Identifier: GPL-3.0-or-later
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
    * [Data types](#data-types)
    * [Facts](#facts)
    * [Functions](#functions)
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

**Data types:**

**Facts:**

**Functions:**


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

##### `buildroot_dependencies`
A hash whose keys are buildroot-dependency resource names and whose values are hashes comprising the same parameters you would otherwise pass to the [koji\_helpers::buildroot\_dependency](#koji\_helpersbuildroot\_dependency-defined-type) defined type.  The default is none.

##### `config`
The filename of the main koji-helpers configuration file.  The default should be correct for supported platforms.

##### `exclude_tags`
An array of tags which smashd should ignore.  The default is `['trashcan']`.

##### `enable`
Services are to be started at boot.  Either `true` (default) or `false`.

##### `ensure`
Services are to be `'running'` (default) or `'stopped'`.  Alternatively, a Boolean value may also be used with `true` equivalent to `'running'` and `false` equivalent to `'stopped'`.

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

##### `mash_path`
Name of the directory into which this repository is to be mashed by smashd.  Defaults to the value set by *repo_name*.

##### `repo_name`
This may be used in place of *namevar* if it's beneficial to give namevar an arbitrary value.


### Data types

### Facts

### Functions


## Limitations

Tested on modern CentOS releases, but likely to work on any Red Hat variant.  Adaptations for other operating systems should be trivial as this module follows the data-in-module paradigm.  See `data/common.yaml` for the most likely obstructions.  If "one size can't fit all", the value should be moved from `data/common.yaml` to `data/os/%{facts.os.name}.yaml` instead.  See `hiera.yaml` for how this is handled.

## Development

Contributions are welcome via pull requests.  All code should generally be compliant with puppet-lint.
