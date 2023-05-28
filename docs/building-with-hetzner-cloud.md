# Running Builds on Hetzner Cloud

Zeppelin can orchestrate spawning a cloud server instance on Hetzner Cloud,
running the build operations on said server, fetching the results back to the
users computer, and deleting the cloud server as a final clean up operation.

> :warning: Be warned! If the build fails or is cancelled midway through, the
> server instance is not automatically cleaned up! Later I intend to add a
> playbook to help do manual clean ups but until then you should keep an eye on
> the usage billing of your account to avoid any nasty surprises.

## Additional Requirements

To build with Hetzner Cloud, [you need an existing account][1] and you need to
[generate an API key][2] and [add it to the shell as environment variable][3]:
`HCLOUD_TOKEN`.

```
export HCLOUD_TOKEN=abc123
```

In addition to having [Ansible installed][4], you must also install the [hcloud
pypi package][5] and the [hetzner.hcloud Ansible module][6]. This enables the
playbooks to interact with the Hetzner Cloud API.

```
pip install hcloud
ansible-galaxy collection install hetzner.hcloud
```

You also need to have an [ssh key set up in your Hetzner account][7].

## Configuration

You must change the ssh keys mentioned in the config.yaml to match [those you
set up in your Hetzner account][7]. These keys will be imported to the VMs on
creation and that will be how Ansible accesses the remote builder.

Example (Where the ssh key is named michael@fedora):

```
- hcloud_aarch64_ssh_keys
    - "michael@fedora"
- hcloud_x86_64_ssh_keys
    - "michael@fedora"
```

This should match the keys on the host computer running Ansible.

The other Hetzner Cloud config options are documented in [config.md](/docs/config.md).

## Usage

You can run a build with Hetzner cloud by invoking `ansible-playbook` on the
`hetzner-cloud.yaml` playbook with the hetzner-cloud inventory.

```
ansible-playbook -i inventories/hetzner-cloud/hcloud.yaml hetzner-cloud.yaml
```

The results of the build (on success) can be found in the `out` directory
(created in the current working directory). See the [Outputs section](#Output-Directory)
below for more details on the output contents.

[1]: https://www.hetzner.com/cloud
[2]: https://docs.hetzner.cloud/#getting-started
[3]: https://unix.stackexchange.com/questions/117467/how-to-permanently-set-environmental-variables
[4]: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible
[5]: https://pypi.org/project/hcloud/
[6]: https://docs.ansible.com/ansible/latest/collections/hetzner/hcloud/index.html
[7]: https://community.hetzner.com/tutorials/add-ssh-key-to-your-hetzner-cloud
