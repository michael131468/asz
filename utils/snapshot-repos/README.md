# snapshot-repos

A wrapper script around the `dnf reposync` plugin to download rpm repositories
in order to freeze upstream repositories as local mirrors and archives.

## Usage

Build the container and run it. When running, mount a local path into the
container and set the inner path as the third parameter (the download
directory).

The following example downloads the x86_64 BaseOS repository from CentOS Stream
9.

```
mkdir -p baseos/x86_64/os
podman build -t snapshot-repos:latest .
podman run \
  --rm \
  -v ./baseos/x86_64/os:/mnt \
  -it snapshot-repos:latest \
  "baseos" \
  "https://mirror.stream.centos.org/9-stream/BaseOS/x86_64/os/" \
  "/mnt"
```
