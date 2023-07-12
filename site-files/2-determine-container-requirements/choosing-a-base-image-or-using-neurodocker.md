---
layout: default
title: Choosing a base image or using Neurodocker
parent: Determine container requirements
nav_order: 3
---

# Choosing a "base image" for your container

At this point you have determined which containerization platform you want to use and finalized the structure of your workflow into a command list. You've figured out which programs you need for your commands and started to consider the sources of those programs and files. 

In subsequent steps you will be setting up a container definition file that incorporates the programs and scripts your workflow uses, including a script constructed from the command list you just tested.

## A "base image"

The first step of setting up a container image definition file is to determine what "base image" you will build your image on top of. 

A base image can either be an image that is a plain "bare-bones" operating system environment with no features added, or it can be a more complex image that has been added onto to include more programs, configurations, and features. 

When setting up a Docker image definition file, the base image must be an existing Docker image, either stored on Docker Hub or locally built or stored on your computer. 

For Apptainer you can use existing Apptainer/Singularity images, Docker images, or a couple other sources. 

### Bare-bones operating system image or existing image? 

When choosing a base image for your container, you can use an operating system with no programs installed yet, or you can choose n image that someone else built previously and installed software into. With either choice you will install your programs and scripts on top of whatever is already in the base image. 

Here are a few considerations when choosing a base image:

### Does your workflow output need to match existing processing that has happened on particular machines?
Some programs like Freesurfer won't provide consistent results across different environments. But if you are trying to get as close a result as possible to an existing system, you can choose an operating system container image that is close to the original system you are trying to match. 

For example, if you are running your local test on a machine that is running Ubuntu 20.04, you could use the Ubuntu 20.04 Docker base image for your Dockerfile or Apptainer definition file.

(Again, note that exact replication of output between containerized and non-containerized systems may not be possible. Some programs like FreeSurfer are sensitive to small software differences in system libraries, operating system versions, and program versions and may not be able to match prior results exactly once containerized.) 

### Are you only going to need to install one or two major imaging programs in your container, e.g. FreeSurfer or FSL? 
There might already be an official or unofficial container image that was created for one of the main programs you need for your workflow. If you start with an operating system image with no programs installed, you will need to add the program installation steps to the definition file yourself, and make sure they are correct for the image build step to work. If an existing image has already done that, you can use that as your base image and save yourself some work. 

Finding an existing container image to build on top of can save time if installing a particular program has a lot of complex dependencies or configurations. However, this way you won't get to choose which operating system your container environment uses - you will end up with the operating system and environment that was set up in whatever program container image you use.

### Does your script require a specific version of a program or programming language?
You can use a pre-built image built for that program and choose a specific version tag for that image based on which version of the program or language you need. For example, if you need to use version Python 3.7.16 exactly, you can use python:3.7.16 as your base image, or choose a specific version of an image using the tag for the version you want. You can check Docker Hub for a particuar image and view the tag list to see which version options are available. For example, choose from [the official Python container tag list on Docker Hub] or [the official FreeSurfer group's container tag list on Docker Hub]. 

### Does the operating system and OS version make a difference in your processing or code? 
If so, you will want to be sure you choose a base image that uses that operating system. Using a base image that was created for a particular program will use the operating system chosen by the developers of the image. For example some of the official `freesurfer/freesurfer` Docker images use CentOS 8 as a base image, so if you need your container to be Ubuntu-based, you will want to use a tag from the [Ubuntu container image tags] as your base image rather than using the pre-built Freesurfer image. 

## Finding official images to use for your image

Many "official" Docker and Apptainer images exist. Docker offers [Docker Hub], a large repository of public images, which contains a set of images deemed "official images" and are widely used and supported. A list of official images can be found with [a Docker Hub search for official images]. Singularity/Apptainer images don't have a single centralized repository but there are a [Singularity Community image catalog] and a [Sylabs image library] you can browse through. You can use any Docker image as a base image for Apptainer builds. 

If you want to try to find an existing base image with one of your required programs to build from, you can look for built images for these programs that have been shared. You can search on the Docker Hub or Sylabs public repositories for the program you need, find out if it is an "official" build or if you are OK with using someone's "unofficial" customization, then determine if it meets your operating system and environment requirements, and choose the tag of the version you want to use. 

For example, the FreeSurfer group has developed a set of official FreeSurfer images and [hosts them on Docker Hub]. At the time of writing there appears to be a set of [official FSL images on Docker Hub] but they have only containerized a few more recent versions of FSL, so if you need an older version you will have to find one that someone else put together or build your own.

There are other sources of images you can build off of ("[preferred bootstrap agents]") for Apptainer/Singularity but for simplicity I will focus on building an image from a base operating system image or on top of the official `[freesurfer/freesurfer:7.3.2]` Docker program image.

# Consider whether you can use Neurodocker to save time

If your workflow uses some commonly used neuroimaging programs, you can use the command-line program [Neurodocker] to generate a container image definition file for you to add your script and customizations to. 

Neurodocker is available as a container image which allows you to run the Neurodocker command-line program, either via their own Docker or Apptainer container, or via a local installation. More details can be found on [the Neurodocker installation page]. 

The concept is that you install and run the Neurodocker command line program with input parameters that you specify, and Neurodocker will output a container definition file with those specifications. With Neurodocker you can specify
- Whether you want a Docker or Apptainer/Singularity definition file
- Which base image you want
- Which of their available neuroimaging programs you want to incorporate into the container image definition file
- Which versions of those neuroimaging programs to include in your container (of the versions they offer as options). 

Neurodocker provides options to copy in external files like the converted workflow script that we will create in this tutorial and specify environment variables that you want included. So this means that if Neurodocker already offers all the neuroimaging programs and versions that you require, you could feasibly generate your whole container definition file using Neurodocker! Then you can skip ahead to the image build steps of this tutorial.

You can look at the [Neurodocker user guide command-line interface section] for a list of the programs, program versions, and options that Neurodocker currently offers. You can check the Neurodocker examples page to see examples of how you would use it to generate a container image definition file and include common programs.

----
[the official Python container tag list on Docker Hub]:https://hub.docker.com/_/python/tags
[the official FreeSurfer group's container tag list on Docker Hub]:https://hub.docker.com/r/freesurfer/freesurfer/tags
[Ubuntu container image tags]:https://hub.docker.com/_/ubuntu/tags
[Docker Hub]: https://hub.docker.com
[a Docker Hub search for official images]: https://hub.docker.com/search?image_filter=official&q=&type=image
[Singularity Community image catalog]: https://singularityhub.github.io/singularity-catalog
[Sylabs image library]:https://cloud.sylabs.io/library/library
[hosts them on Docker Hub]: https://hub.docker.com/r/freesurfer/freesurfer/tags
[official FSL images on Docker Hub]: https://hub.docker.com/r/fnndsc/fsl/tags
[preferred bootstrap agents]: https://apptainer.org/docs/user/main/definition_files.html#preferred-bootstrap-agents
[freesurfer/freesurfer:7.3.2]:https://hub.docker.com/r/freesurfer/freesurfer
[Neurodocker]:https://www.repronim.org/neurodocker
[the Neurodocker installation page]:https://www.repronim.org/neurodocker/user_guide/installation.html
[Neurodocker user guide command-line interface section]:https://www.repronim.org/neurodocker/user_guide/cli.html
[Neurodocker examples page]:https://www.repronim.org/neurodocker/user_guide/examples.html