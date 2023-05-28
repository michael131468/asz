# asz

Automotive-SIG Zeppelin - Take your automotive-sig builds to the clouds

## About

Zeppelin is a meta build system for the [Automotive-SIG sample-images][1]
project with the goal being to enable building customised AutoSD system images
using the cloud.

Zeppelin at this time only supports building either locally (on supported
distros) or on [Hetzner Cloud][2]. Thanks to their current low pricing for
Ampere vCPUs (at the time of writing), this means being able to assemble
aarch64 system images without emulation for only a few cents per build!

## Background

The [CentOS Automotive-SIG project][3] provides a Makefile-based build system to
assemble system-images (with OSBuild). This build system supports configuration
via both command line parameters and custom yaml snippet files that extend /
overwrite the default image configuration.

The aim of Zeppelin is to add (yet another) abstraction layer to operate that
Makefile-based build system with the intended benefits of simplifying the
management of the configurations and abstracting out the host builder set up
(allowing you to transparently build in the cloud or locally with no change in
the build-system entrypoint).

For now, Zeppelin aims to focus on building with the [Hetzner Cloud][2]. Support
for more cloud providers and other potential build hosts will be added in the
future.

## How It Works

Zeppelin is a simple set of Ansible playbooks and roles with a configuration
file to control the build process. The playbooks are run on an Ansible host
machine (typically the developer machine). The playbooks can set up a build
host machine (eg. instantiate a machine in Hetzner Cloud), run the build
instructions remotely on the build host machine, and gather the output files
back to the Ansible Host local filesystem.

![zeppelin-diagram](/docs/images/zeppelin-diagram.png)

This is a workflow which on the surface appears like a developer is running the
system images assembly locally when actually it will transparently be processed
in the cloud.

While the main example case is using the cloud as a source of build hosts,
the build host could also be the local Ansible host itself or another available
networked machine like a Raspberry Pi. Any host that Ansible can provision,
set up, and use to execute build instructions is viable with Zeppelin.

The Ansible host machine also need not always be the developer machine. Another
use case of Zeppelin is running system-image assembly in a CI/CD workflow. There
the Ansible host machine would be the pipeline runner that executes the CI/CD
workflow (eg. GitHub runner). This could be useful to avoid needing Arm64
machines in the pipeline execution (which for example is not available
as a public GitHub runners) and aligning CI workflows with developer workflows.

<a href="https://www.flaticon.com/free-icons/productivity" title="productivity icons">Productivity icons created by vectorsmarket15 - Flaticon</a>

<a href="https://www.flaticon.com/free-icons/server" title="server icons">Server icons created by vectorsmarket15 - Flaticon</a>

## Requirements

Since Zeppelin is based on Ansible, you must have it installed on the computer
that starts the build process (aka your personal computer). Typically you can
install Ansible with pip.

```
python3 -m pip install --user ansible
```

You can find out more [here][4] on how to install it.

In addition to having installed ansible, you need the [community.general
Ansible collection][5] installed also.

```
ansible-galaxy collection install community.general
```

## Configuration

The build host and system-image target build configuration is defined in
`config.yaml`. This yaml file is loaded by the different roles to dynamically
configure them at runtime.

A deep dive in the `config.yaml` can be found in:
[docs/config.md](docs/config.md).

The minimal config to get started are the three following variables which
configure the system image build target:

- target_image
- target_arch
- target_filetype

These variables align with the [Automotive-SIG Makefile targets][3] so you can
refer to their documentation for details.

In the future there will be a simple `configure.sh` to help generate this
configuration yaml.

## Usage

Zeppelin supports a variety of use cases and configuration/instructons differ
for each. Details for each use case can be found in the linked documents.

- [Running builds locally](docs/building-locally.md)
- [Running builds on Hetzner Cloud](docs/building-with-hetzner-cloud.md)
- [Running builds on AWS EC2](docs/building-with-aws-ec2.md)
- [Running builds with tmt](docs/building-with-tmt.md)

Some common scenarios are also documented:

- [How can I run Zeppelin locally with a modified sample-images repository?][faq1]
- [How can I run Zeppelin locally with a modified custom-images repository?][faq2]

[faq1]: /docs/faq/modified-sample-images.md
[faq2]: /docs/faq/modified-custom-images.md

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

## License

This project is licensed under the MIT license (see LICENSE file).

[1]: https://sigs.centos.org/automotive/
[2]: https://www.hetzner.com/cloud
[3]: https://sigs.centos.org/automotive/building/#using-makefile-to-build-the-image
[4]: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible
[5]: https://galaxy.ansible.com/community/general
