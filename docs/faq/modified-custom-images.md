# FAQ: How can I run Zeppelin locally with a modified custom-images repository?

You cannot edit the working paths of Zeppelin to test changes to the
custom-images project because Zeppelin will clean up these directories during
its runtime.

You should instead manually clone and set up a local copy of custom-images
elsewhere and set the variable `local_custom_images` in `config.yaml` to point
to it. This will cause Zeppelin to copy your local copy in-place instead of
cloning custom-images from the url specified by `custom_images_git_url`.

Eg.

```
# Create local copy of custom-images
git clone https://gitlab.com/redhat/edge/ci-cd/pipe-x/custom-images.git ~/custom-images
echo "my-edited-file" > ~/custom-images/my-file.txt

# Edit config.yaml to use this local repo
echo 'local_custom_images: "{{ ansible_env.HOME }}/custom-images' >> config.yaml
```
