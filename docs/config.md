# Configuration YAML

Zeppelin is configured via a config.yaml file in the base directory. The file
is split into three sections, basic, project, and advanced configuration.
Typically you only want to modify the basic section to begin building. Later one
would dig deeper and need to modify the project configuration to customise the
build targets. And finally one might need to modify the advanced configuration
to tune the build process (to use custom repositories, etc).

This document explains the different configuration tuning variables in the
config.yaml.

# Link to Automotive-SIG sample-images Makefile

Many of the configuration parameters are based around the configuration of the
Makefile in the sample-images project. You should read [this doc][1] as
preliminary reading before trying to understand how to configure Zeppelin.

You can also find more info by running `make help` with the [Automotive-SIG
sample-images Makefile][2].

[1]: https://sigs.centos.org/automotive/building/#using-makefile-to-build-the-image
[2]: https://gitlab.com/CentOS/automotive/sample-images/-/blob/main/osbuild-manifests/Makefile

# Basic Configuration

- `target_image`

  Specifies the target image to assemble with the sample-images Makefile. This
  aligns to the first part of the Makefile target when using the Makefile
  directly.

  eg. `cs9-qemu-minimal-ostree`

- `target_arch`

  Specifies the architecture of the target image to assemble. This aligns to
  the second part of the Makefile target when using the Makefile directly.

  i.e. `x86_64` or `aarch64`

- `target_filetype`

  Specifies the output image file type. This aligns to the third part of the
  Makefile target when using the Makefile directly.

  eg. qcow2

- `target_compression`

  Optionally specifies a compression format for the output image file. This
  allows for compressing the image immediately after creation to save space
  and bandwidth when transferring.

  Supported values include:
    - bz2
    - gz
    - xz
    - zip

  eg. `gz`

- `custom_images_git_url`

  Optionally specifies a secondary git repository to clone into the host system
  to use with the Makefile parameter, `IMAGEDIR`. This allows for extending the
  Makefile targets with custom images beyond those defined in the sample-images
  project.

  eg. <https://gitlab.com/redhat/edge/ci-cd/pipe-x/custom-images.git>

- `custom_images_git_ref`

  Specifies the git reference to use when cloning `custom_images_git_url`.

  eg. `main`

- `custom_images_workdir`

  Specifies the local path to clone `custom_images_git_url` into.

  eg. `{{ ansible_env.HOME }}/custom-images`

- `local_custom_images`

  Specifies a local directory to use as a source for the custom-images instead
  of cloning the git repo specified in `custom_images_git_url`.

- `local_sample_images`

  Specifies a local directory to use as a source for the sample-images instead
  of cloning the git repo specified in `sample_images_git_url`.

- `osbuildvm_images_build`

  Toggles on the building of osbuildvm images. A truthful value is the on state
  and the undefined or falsey value is the off state.

  eg. `yes`

# Project Configurations

- `distros`

  Specifies a list of dictionaries to configure the distro files in the
  `sample-images` project. Each dictionary must define the `distro_name` key
  to indicate which distro file is to be injected/updated. The dictionary
  contents are outputted under the `mpp-vars` keys in the output file (see the
  [default cs9 distro file][3] to understand further).

  If the distro file already exists and has content, the existing content is
  updated by merging the new values on top (leaving the old content in place).

[3]: https://gitlab.com/CentOS/automotive/sample-images/-/blob/main/osbuild-manifests/distro/cs9.ipp.yml

# Advanced Configuration

These configuration parameters are configured with sane defaults to get started
with running Zeppelin. You should only modify these values when intending to
force Zeppelin to build with custom resources such as a fork of the
Automotive-SIG sample-images project.

- `osbuild_vmimages_download_baseurl`

  This parameter directs where Zeppelin should download the osbuildvm-images
  from. This is needed for cross-arch assembly (eg. building aarch64 images on
  x86_64 hosts).

  More information about osbuild-vmimages can be found [here][4].

- `osbuild_packages`

  This parameter contains a mapping of osbuild packages to rpm names/versions.
  The default values mapped to the package names are the names of the rpms which
  will make Zeppelin use the latest versions available.

  It can be used to pin specific versions of osbuild by setting the values to
  &lt;name&gt;-&lt;version&gt; instead of only &lt;name&gt;.

  Example:
  ```
  osbuild_packages:
    - package: "osbuild"
      value: "osbuild-84-1.20230505134457921609.main.12.gdfcd847.el9"
    - package: "osbuild-tools"
      value: "osbuild-tools-84-1.20230505134457921609.main.12.gdfcd847.el9"
    - package: "osbuild-ostree"
      value: "osbuild-ostree-84-1.20230505134457921609.main.12.gdfcd847.el9"
    - package: "osbuildtest-ostree-compliance-mode"
      value: "osbuildtest-ostree-compliance-mode-84-1.20230505134457921609.main.12.gdfcd847.el9"
  ```

- `sample_images_git_url`

  Specifies the git url for the sample-images project to clone.

  eg. `https://gitlab.com/CentOS/automotive/sample-images.git`

- `sample_images_git_ref`

  Specifies the git reference to use when cloning `sample_images_git_url`.

  eg. `main`

- `sample_images_workdir`

  Specifies the local path to clone `sample_images_git_url` into.

  eg. `{{ ansible_env.HOME }}/sample-images`

- `sample_images_build_path`

  Specifies the temporary work directory for the Makefile to use when
  assemblying the target image. This should typically not be changed as the
  defaults line up to the standard operation for the Makefile.

  eg. `{{ sample_images_workdir }}/osbuild-manifests/_build`

[4]: https://sigs.centos.org/automotive/building/#building-in-a-virtual-machine

## Advanced Configration: Hetzner Cloud Configuration

These configuration parameters only apply when using Hetzner Cloud.

- `hcloud_aarch64_server_type`

  To be documented.

- `hcloud_aarch64_image`

  To be documented.

- `hcloud_aarch64_location`

  To be documented.

- `hcloud_aarch64_ssh_keys`

  To be documented.

- `hcloud_x86_64_server_type`

  To be documented.

- `hcloud_x86_64_image`

  To be documented.

- `hcloud_x86_64_location`

  To be documented.

- `hcloud_x86_64_ssh_keys`

  To be documented.
