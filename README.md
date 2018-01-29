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

**Defined types:**


### Classes


### Defined types


## Limitations

Tested on modern CentOS releases, but likely to work on any Red Hat variant.  Adaptations for other operating systems should be trivial as this module follows the data-in-module paradigm.  See `data/common.yaml` for the most likely obstructions.  If "one size can't fit all", the value should be moved from `data/common.yaml` to `data/os/%{facts.os.name}.yaml` instead.  See `hiera.yaml` for how this is handled.

This should be compatible with Puppet 4.x.

## Development

Contributions are welcome via pull requests.  All code should generally be compliant with puppet-lint.
