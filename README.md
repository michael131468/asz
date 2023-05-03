# asz

Automotive-SIG Zeppelin - Take your automotive-sig builds to the clouds

## About

Zeppelin is a meta build system for the [Automotive-SIG sample-images][0]
project with the goal being to enable building customised AutoSD system images
using the cloud.

Zeppelin at this time only supports building locally (on supported distros).

## Background

The [CentOS Automotive-SIG project][1] provides a Makefile-based build system to
assemble system-images (with OSBuild). This build system supports configuration
via both command line parameters and custom yaml snippet files that extend /
overwrite the default image configuration.

The aim of Zeppelin is to add (yet another) abstraction layer to run that
Makefile-based build system with the intended benefits of simplifying the
management of the configurations and abstracting out the host builder set up
(allowing you to transparently build in the cloud or locally with no change in
the build-system entrypoint).

For now, Zeppelin aims to focus on building with the [Hetzner Cloud][2]. Support
for more cloud providers will be added in the future.

## How It Works

Zeppelin is actually a simple set of Ansible playbooks and roles with a
configuration file to control the build process. The choice to use Ansible
may seem limiting compared to a programmable build script but the reasoning for
this choice of architecture includes:

- it allows re-using the "builtin" playbooks and roles to simplfy the build
  host preparation
- it allows for having one "method" definition that can run both locally or
  remotely with minimal code changes

## Configuration

The build host and system-image target build configuration is defined in
`config.yaml`. This yaml file is loaded by the different roles to dynamically
configure them at runtime.

The system image build target is configured with the variables:

- target_image
- target_arch
- target_filetype

These variables align with the [Automotive-SIG Makefile targets][1] so you can
refer to their documentation for details.

In the future there will be a simple `configure.sh` to help generate this
configuration yaml.

## Requirements

Since Zeppelin is based on Ansible, you must have it installed on the computer
that starts the build process (aka your personal computer). You can find out
more [here][3] on how to install it.

## Running Builds Locally

Zeppelin can orchestrate the build operations on the local computer that runs
Ansible. Local builds are supported given the host machine is one of the
supported distros:

- Fedora 37

You can run a local build by invoking `ansible-playbook` on the `local.yaml`
playbook with the `-K` parameter.

```
ansible-playbook local.yaml -K
```

The `-K` parameter is needed because sudo/root privileges are needed to run
OSBuild.

> :warning: If the builder cpu architecture is x86_64 and an aarch64 system
> image is configured as the build target, qemu will be used automatically to
> wrap the build process (see [Building in a virtual machine][4]) but this
> will be very slow to complete.

The results of the build (on success) can be found in the `out` directory
(created in the current working directory). See the Outputs section below for
more details on the contents.

## Output Directory

Zeppelin will create a directory named `out` in your current working directory
where `ansible-playbook` was called.

This `out` directory will be populated during the build process with the log
files from the different stages of the playbook (with the naming scheme:
`log.<role-name>.txt`). The resulting system-image file generated, if
successful, will also be copied there (eg.
`cs9-qemu-minimal-regular.aarch64.qcow2`).

In the future, more outputs such as manifests of packages and reproducability
scripts may be added to the resulting directory.

> :warning: The output directory is not cleaned automatically between runs of
> the playbooks so you must manually do so.

[0]: https://sigs.centos.org/automotive/
[1]: https://sigs.centos.org/automotive/building/#using-makefile-to-build-the-image
[2]: https://www.hetzner.com/cloud
[3]: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible
[4]: https://sigs.centos.org/automotive/building/#building-in-a-virtual-machine
