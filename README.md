# asz

Automotive-SIG Zeppelin - A meta build system for automotive-sig sample-images

## About

The CentOS Automotive-SIG provides a Makefile based build system to construct system-images (wrapping OSBuild). This build system supports configuration via both command line parameters and also through custom yaml snippets that extend the base image configuration.

The aim of Zeppelin is to add (yet another) abstraction layer to run that Makefile build system with the benefit of managing those configurations and to abstract out the host builder set up (allowing you to transparently build on the cloud or locally).
