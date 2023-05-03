# asz

Automotive-SIG Zeppelin - Take your automotive-sig builds to the sky

## About

Zeppelin is a meta build system for the Automotive-SIG sample-images project
with the goal being to enable building customised AutoSD sample images in the
cloud.

Currently Zeppelin only supports building either locally (on supported distros)
or on [Hetzner Cloud][1]. Thanks to their current low pricing for Ampere vCPUs
(at the time of writing), this means being able to build aarch64 system images
without emulation for only a few cents per build!

## Background

The CentOS Automotive-SIG provides a Makefile based build system to construct
system-images (wrapping OSBuild). This build system supports configuration via
both command line parameters and also through custom yaml snippets that extend
the base image configuration.

The aim of Zeppelin is to add (yet another) abstraction layer to run that
Makefile build system with the benefit of managing those configurations and to
abstract out the host builder set up (allowing you to transparently build on
the cloud or locally with no change in the entrypoint).

For now though, Zeppelin aims to focus on just building with the Hetzner Cloud.
I intend to later add support for more cloud providers.

## How It Works

Zeppelin is actually a simple set of Ansible playbooks and roles with a
configuration file to control the build process. The choice to use Ansible
may seem limiting compared to a standalone build script but the reasoning for
this choice of architecture includes:

- it allows re-using the "builtin" playbooks and roles to simplfy the build
  host preparation
- 
- it allows for having one method definition that can run both locally or
  remotely with minimal code changes

## Configuration

The build host and system-image target build configuration is defined in
`config.yaml`. This yaml file is loaded by the different roles to dynamically
configure them at runtime.

The system image build target is configured with the variables:

- target_image
- target_arch
- target_filetype

This aligns with the Automotive-SIG [Makefile targets][4] so you can refer to
their documentation for details.

In the future there will be a simple `configure.sh` to help generate this
configuration yaml.

## Requirements

Since Zeppelin is based on Ansible, you must have it installed on the computer
that starts the build process (aka your personal computer). You can find out
more [here][2] on how to install it.

## Running Builds Locally

Zeppelin can orchestrate the build operations on the local computer that runs
Ansible. Local builds are supported given the host machine is one of the
supported distros:

- Fedora 37

You can run a local build by invoking ansible-playbook on the `local.yaml`
playbook with the `-K` parameter.

```
ansible-playbook local.yaml -K
```

The `-K` parameter is needed because sudo/root privileges are needed to run
OSBuild.

The results of the build (on success) can be found in the `out` directory
(created in the current working directory). See the Outputs section below for
more details on the contents.

## Running Builds on Hetzner Cloud Builds

Zeppelin can orchestrate spawning a cloud server instance on Hetzner Cloud,
running the build operations on said server, fetching the results back to the
local computer, and deleting the cloud server as a final clean up operation.

> :warning: Be warned! If the build fails or is cancelled midway through, the
> server instance is not automatically cleaned up! Later I intend to add a
> playbook to help do manual clean ups but until then you should keep an eye on
> the usage billing of your account to avoid any nasty surprises.

To run builds with Hetzner Cloud, [you need an existing account][1] and you
need to [generate an API key][3] and add it as the shell environment variable:
`HCLOUD_TOKEN`.

```
export HCLOUD_TOKEN=abc123
```

In addition to having [Ansible installed][2], you must also install the hcloud
pypi package and the hetzner.hcloud Ansible module. This enables the playbooks
to interact with the Hetzner cloud API.

```
pip install hcloud
ansible-galaxy collection install hetzner.hcloud
```

You can run a build with Hetzner cloud by invoking ansible-playbook on the
`hetzner-cloud.yaml` playbook with the hetzner-cloud inventory.

```
ansible-playbook -i inventories/hetzner-cloud/hcloud.yaml hetzner-cloud.yaml
```

The results of the build (on success) can be found in the `out` directory
(created in the current working directory). See the Outputs section below for
more details on the contents.

## Output Directory

Zeppelin will create a directory named `out` in your current working directory
which is typically the base directory of this project on your personal computer
where these playbooks are triggered from.

Inside this out directory, there will be log files from the different stages of
the playbook (with the naming scheme: `log.<role-name>.txt`). There will also
be the system image generated if successful (eg.
`cs9-qemu-minimal-regular.aarch64.qcow2`) and the related manifest of packages
installed.

[1]: https://www.hetzner.com/cloud
[2]: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible
[3]: https://docs.hetzner.cloud/#getting-started
[4]: https://sigs.centos.org/automotive/building/#using-makefile-to-build-the-image
