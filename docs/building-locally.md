# Running Builds Locally

Zeppelin can orchestrate the build operations on the local computer that runs
Ansible. Local builds are supported given the host machine is one of the
supported distros:

- Fedora 37
- Fedora 38
- CentOS Stream 9
- Red Hat Enterprise Linux 9

# Usage

You can run a local build by invoking `ansible-playbook` on the `local.yaml`
playbook with the `-K` parameter.

```
ansible-playbook local.yaml -K
```

The `-K` parameter is needed because sudo/root privileges are needed to run
OSBuild.

> :warning: If the builder cpu architecture is x86_64 and an aarch64 system
> image is configured as the build target, qemu will be used automatically to
> wrap the build process (see [Building in a virtual machine][1]) but this
> will be very slow to complete.

The results of the build (on success) can be found in the `out` directory
(created in the current working directory). See the [Outputs section below](#Output-Directory)
for more details on the output contents.

[1]: https://sigs.centos.org/automotive/building/#building-in-a-virtual-machine
