# Running Builds with tmt

We can abuse [tmt (test management tool)][1] to run Zeppelin in a virtual
machine (locally). tmt is a testing framework tool that runs tests in an
ansible-style workflow and has inbuilt provisioning mechanisms to spawn said
test plans in containers, virtual machines or locally with no wrapper.

Zeppelin takes advantage of this by having a tmt test plan (see:
`./tmt/zeppelin.fmf`) that simply executes Zeppelin and extracts the resulting
output files back to the host operating system.

## Additional Requirements

To build with tmt, you need tmt installed on the local system in addition to
the base requirements (Ansible).

## Usage

You can run the tmt test plan locally by calling `tmt run`.

```
tmt run -vvvv
```

Using -vvvv as a parameter enables an excessive logging level which provides
live logs of the Zeppelin process.

The output will not be stored in the `out` directory like the other execution
methods did so far. When tmt is executed, the first line it prints will show
its working directory (eg. `/var/tmp/tmt/run-001`) and it's under this directory
where the output data will end up.

Example:

```
$ ls -al /var/tmp/tmt/run-001/tmt/zeppelin/data/out
total 242208
-rw-r--r--. 1 michael michael    128911 May  4 16:47 cs9-qemu-minimal-regular.x86_64.json
-rw-r--r--. 1 michael michael 247791616 May  4 16:47 cs9-qemu-minimal-regular.x86_64.qcow2
-rw-r--r--. 1 michael michael       103 May  4 16:47 log.clone_sample_images.txt
-rw-r--r--. 1 michael michael       501 May  4 16:47 log.init.txt
-rw-r--r--. 1 michael michael      4407 May  4 16:47 log.prepare_osbuild.txt
-rw-r--r--. 1 michael michael     79027 May  4 16:47 log.run_make.txt
```

[1]: https://tmt.readthedocs.io/en/stable/overview.html
