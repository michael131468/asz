# FAQ: How can I run Zeppelin locally with a modified sample-images repository?

You cannot edit the working paths of Zeppelin to test changes to the
sample-images project because Zeppelin will clean up these directories during
its runtime.

You should instead manually clone and set up a local copy of sample-images
elsewhere and set the variable `local_sample_images` in `config.yaml` to point
to it. This will cause Zeppelin to copy your local copy in-place instead of
cloning sample-images from the url specified by `sample_images_git_url`.

Eg.

```
# Create local copy of sample-images
git clone https://gitlab.com/CentOS/automotive/sample-images.git ~/sample-images
echo "my-edited-file" > ~/sample-images/my-file.txt

# Edit config.yaml to use this local repo
echo 'local_sample_images: "{{ ansible_env.HOME }}/sample-images' >> config.yaml
```
