---
layout: default
title: Choosing Docker or Singularity/Apptainer
parent: Getting started
nav_order: 2
---

# Choosing Docker vs. Apptainer

These examples are limited to containerization using two platforms: [Docker] or [Singularity/Apptainer]. You'll need to decide which platform to start with for containerization.

## Clarifying Apptainer vs. Singularity

Apptainer and Singularity are essentially the same at the time of writing. 

### Brief Singularity history

Singularity was originally developed as an open source project. A company, Sylabs, was created by the original Singularity author to provide commercial support for Singularity use. The original author then left the Sylabs company but continued to work on the open source version of the Singularity project. Sylabs created their own fork of that open source Singularity project, SingularityCE, for "Community Edition", in May 2021. In November 2021 the main Singularity open source project (not the SingularityCE fork) joined the Linux Foundation in order to enable its continued open source development, and the name was changed to Apptainer to differentiate it from the Sylabs SingularityCE fork.[^1][^2] Whew!

So in summary: 
Singularity = Original free and open source project that is now Apptainer
[Apptainer] = Free and open source, formerly named Singularity, under the [Linux Foundation]
[SingularityCE] = Fork of original Singularity from May 2021, free and open source, owned by a company
[Sylabs] = Company that runs the SingularityCE May 2021 fork and offers paid versions of Singularity too

### What all that means

When running commands for `singularity` and `apptainer`, they are currently (as of July 2023) so functionally similar as to be identical, and there is a lot of overlap in their documentation, but you may encounter differences in the future as Apptainer development continues and diverges from Sylabs' Singularity. 

This tutorial will focus on using `apptainer` commands and the Apptainer documentation, but right now these commands should work with `singularity` in place of `apptainer` also.

## Considerations when choosing Apptainer vs Docker

### High-performance computing systems

Apptainer/Singularity is frequently used on shared high-performance computing systems so may be best if you are are planning to use a high-performance compute cluster for work on large datasets that require a lot of resources. If you are planning to use a particular system, check with your institution or the compute cluster administration to find out what container platform they use.

### Security and permissions concerns

Your institution may recommend or require a particular platform for security reasons. 

Some IT departments may be hesitant to provide users with access to a shared Docker server setup. 

Docker requires a process called the Docker daemon to run in the background. That process requires root privileges for basic tasks like building images and running containers. Users must have permission to run Docker commands so there is potential for exploit risk if users are given Docker command access.

Apptainer in some cases requires root privileges to build an initial image, but offers a `--fakeroot` feature to allow non-root users to still build images without needing to have those privileges. Once an image is built, users can run containers from built images without requiring special privileges or permissions. If you are using a machine where you do not have admin privileges, you might need to ask your system administrator about getting permissions to use Apptainer's `--fakeroot` feature. This feature provides a user with only the privileges they need to build the image.

If you have admin/root privileges on your computer and have installed Apptainer or Docker yourself, then you most likely won't need to worry about issues with permissions. You would be able to build Docker images using "docker build" or build Apptainer images using "sudo" before your "singularity build" command.

### Disk drive space

Apptainer and Docker container builds will take up varying amounts of space depending on the size of the container images you have on your system, created either from pulling existing ones or building new ones.

For an example image size, the official `freesurfer/freesurfer:7.3.2` FreeSurfer Docker image takes about 15GB of space. A default Ubuntu base image is around 70MB, and you would install any programs you need on top of that size. 

Images are mounted virtually when a container is started, and an additional layer added to store any changes to the container as it runs. So if you pull a FreeSurfer container image and launch 5 FreeSurfer containers from it, the 15GB space would apply only once for the single image. Any new data you are generating with each of those containers would get added to the additional storage layer and add to your total space used. 

Where Docker images are stored is dependent on the administrator's configuration of the Docker storage driver.
Apptainer images are stored as .sif format files in your local folders. Apptainer can be configured to use a [cache directory] where you specify a location where intermediate container image build files are stored.

----

[^1] Lots of this info taken from the [Singularity (software) Wikipedia page]:(https://en.wikipedia.org/wiki/Singularity_(software))
[^2] The [November 2021 Apptainer community announcement](https://apptainer.org/news/community-announcement-20211130) also offers some clarification on this.

[Docker]: https://docs.docker.com/get-started/
[Singularity/Apptainer]: https://apptainer.org/docs/user/latest/
[Apptainer]: https://apptainer.org
[Linux Foundation]: https://linuxfoundation.org
[SingularityCE]: https://sylabs.io/singularity/
[Sylabs]: https://sylabs.io
[cache directory]: https://apptainer.org/docs/user/main/build_env.html#cache-folders