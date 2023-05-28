## Running Builds on AWS with EC2

Zeppelin can orchestrate spawning an AWS EC2 server instance (Virtual Machine),
running the build operations on said server, fetching the results back to the
users computer, and deleting the EC2 server as a final clean up operation.

> :warning: Be warned! If the build fails or is cancelled midway through, the
> server instance is not automatically cleaned up! Later I intend to add a
> playbook to help do manual clean ups but until then you should keep an eye on
> the usage billing of your account to avoid any nasty surprises.

To build with AWS, [you need an existing account][1] and you need to [generate
an access key or security token][2] and [configure your shell environment][3]
as needed (such as setting environment variables like below).

```
export AWS_ACCESS_KEY_ID="xxx"
export AWS_SECRET_ACCESS_KEY="yyy"
```

In addition to having [Ansible installed][4], you must also install the [boto3
pypi package][5] and the [amazon.aws Ansible module][6]. This enables the
playbooks to interact with the AWS EC2 API.

```
pip install boto3
ansible-galaxy collection install amazon.aws
```

You need to have an [SSH key pair already provisioned in your AWS account][7]
and configure the config.yaml accordingly based on the name (see:
`aws_ec2_aarch64_ssh_key` and `aws_ec2_x86_64_ssh_key`). The private key should
be configured for default use with your ssh client.

## Usage

You can run a build with AWS EC2 by invoking `ansible-playbook` on the
`aws-ec2.yaml` playbook with the aws\_ec2 inventory.

```
ansible-playbook -i inventories/aws-ec2/aws_ec2.yaml aws-ec2.yaml
```

The results of the build (on success) can be found in the `out` directory
(created in the current working directory). See the [Outputs section](#Output-Directory)
below for more details on the output contents.

[1]: https://docs.aws.amazon.com/accounts/latest/reference/manage-acct-creating.html
[2]: https://repost.aws/knowledge-center/create-access-key
[3]: https://docs.ansible.com/ansible/latest/collections/amazon/aws/docsite/guide_aws.html#authentication
[4]: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible
[5]: https://boto3.amazonaws.com/v1/documentation/api/latest/index.html
[6]: https://docs.ansible.com/ansible/latest/collections/amazon/aws/docsite/guide_aws.html
[7]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html
