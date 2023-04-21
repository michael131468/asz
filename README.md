# asz

Automotive-SIG Zeppelin - Take your automotive-sig builds to the clouds

## About

Zeppelin is a meta build system for the [Automotive-SIG sample-images][0]
project with the goal being to enable building customised AutoSD system images
using the cloud.

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

[0]: https://sigs.centos.org/automotive/
[1]: https://sigs.centos.org/automotive/building/#using-makefile-to-build-the-image
[2]: https://www.hetzner.com/cloud
