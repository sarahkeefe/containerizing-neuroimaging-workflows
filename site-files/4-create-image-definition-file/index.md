---
layout: default
title: Create image definition file
has_children: false
nav_order: 5
---

# Create a container image definition file for use with Docker or Apptainer

## Starting with the base image or OS

For this tutorial, we are using tools from FSL and FreeSurfer. My local test has been run using FSL 6.0.4 and FreeSurfer 7.3.2. 

I've provided examples of Dockerfiles and Apptainer build files for this example container that were set up a few different ways. Files in the [image-definition-files/example-freesurfer_base_image] folder use the "freesurfer/freesurfer:7.3.2" Docker container as a base image for both the Apptainer and Docker build examples. 

The Apptainer definition file starts with

```
Bootstrap: docker
From: freesurfer/freesurfer:7.3.2
```

This indicates to Apptainer that the base image should be this particular image from Docker Hub, from user "freesurfer", image name "freesurfer", with version tag "7.3.2".

The Dockerfile starts with

```
FROM freesurfer/freesurfer:7.3.2
```

Which has the same effect.

I've also provided an example that uses Ubuntu 22.04 as a base image. Files in the [image-definition-files/example-ubuntu_base_image] folder use the official "ubuntu:22.04" Docker container as a base image for both the Apptainer and Docker build examples. 

The Apptainer definition file starts with

```
Bootstrap: library
From: ubuntu:22.04
```

Apptainer will use the "ubuntu" image, version 22.04, from the Apptainer official image library.

The Dockerfile starts with

```
FROM ubuntu:22.04
```

Which uses Docker's official Ubuntu 22.04 image as the base.

## Container image definition file syntax

After the base container image is set, you will add lines to install the programs you need and configure the container. 

This will give a very brief overview of the important steps for this project, but for more in-depth reference on your chosen platform you can refer to the [Apptainer documentation on Definition Files] and the [Docker Dockerfile documentation].

### Apptainer

In general, an Apptainer definition file contains sections that group the setup steps by type. For example, all environment variables are set in the %environment section of the file.
The example Apptainer definition file that uses Ubuntu as the container base includes the following sections:

```
%files
    [source file] [destination file]
    [source file] [destination file]

%environment
    [environment variable name] [environment variable value]
    [environment variable name] [environment variable value]

%post
    [command 1]
    [command 2]
    [command 3]
```

Your local files get copied in in the `%files` block. The files you have locally should be in the same directory where you will run your `apptainer build` command from.
Any environment variables that need to be set in the container will go in the `%environment` block.
Any installation steps including file download from URLs, unzipping or moving files, package manager steps, or installation script runs, should go in the `%post` block.

Apptainer definition files have other blocks available but for simplicity these are the ones that will be discussed in this tutorial.

### Dockerfile

A Dockerfile can run a set of commands in any order, unlike Apptainer which requires the commands to be organized into blocks by type. Commands in the Dockerfile must use Dockerfile instruction syntax. The Dockerfile commands I will use in this tutorial are:

```
RUN [command]
```

The RUN instruction will run the command you specify in your container image. You would use this for any installation steps, like file download from URLs, unzipping or moving files, package manager steps, or installation script runs. You would use a RUN line for each step. You can also run multiple commands per `RUN` by joining them with `&&` but the whole command will fail if either of them does not work.

```
COPY [source file] [destination file]
```

COPY should be added once for each file or directory you want to copy into your container image. The files you have locally should be in the same directory where you will run your `docker build` command from.

```
ENV [environment variable name] [environment variable value]
```
Use the ENV instruction once for each environment variable you need to set within your container image.


## Copying in your files (any non-public files or programs you have locally)

The Apptainer `%files` section is equivalent to running a bunch of Dockerfile `COPY` commands in a row. First you enter the name of the file locally, and then you say where you want the file to go within the container image. The destination needs to be an absolute path within the container.

In Docker you would enter
```
COPY run_workflow.sh /usr/local/bin/run_workflow.sh
COPY parc /usr/local/parc
```

and in Apptainer the equivalent would be
```
%files
    run_workflow.sh /usr/local/bin/run_workflow.sh
    parc /usr/local/parc
```

This example is copying in my most recent updated script file named `run_workflow.sh` into the container image at the location `/usr/local/bin` also with the filename `run_workflow.sh`. 

You'll also want to incorporate any atlases, reference images, or libraries that you have stored locally but can't get elsewhere. The last lines of these examples are copying my local folder called `parc` and everything in it to the location `/usr/local/parc` within the container image. After the container image is built, any files that are in my local `parc` folder will be copied in at the destination `/usr/local/parc` within my container image. 

You can change the destination names and locations within the container to anything you want, as long as you know how to find them within the container when you need them. For example, let's say my custom `run_workflow.sh` script needs to use the file `parc/Schaeffer200.nii.gz`. I set up my container definition file copy step to copy the parc folder and its contents to `/usr/local/parc`. Then, to access that file from within the container, my `run_workflow.sh` script will need to use the path `/usr/local/parc/Schaeffer200.nii.gz` to find it.  

If you have any license files that are needed for your programs to be operational, you would include lines for them in the file copy steps as well.

When using Docker, it can be useful to add the `COPY` step for your main run script file as one of the last lines in your Dockerfile. This is because `docker build` uses caching to determine what files or lines have changed in the container since the last successful build, and if your script file changes, it reruns the `COPY` step and then all steps after it, which can take extra time. Putting your script file `COPY` step last means that if you can build your container successfully and then need to modify your script, the very fast `COPY` step will be the only step you need to re-do since all prior steps will be pulled from the Docker cache.

## Setting environment variables

Many programs use environment variables for configuration. You'll also want to set the `PATH` variable within your Docker container image so programs you install can be found by default rather than typing the full location of them, e.g. being able to type `fslmaths` instead of `/usr/local/fsl/bin/fslmaths` every time.

Here is an example of setting environment variables in Apptainer syntax:

```
%environment
    export OS=Linux
    export FREESURFER_HOME=/usr/local/freesurfer
```

Here is the equivalent set of commands for a Dockerfile:

```
ENV OS Linux
ENV FREESURFER_HOME /usr/local/freesurfer
```

These lines are the equivalent of setting
```
export OS=Linux
```
in a bash shell, or setting
```
setenv OS Linux
```
in tcshell.

Any environment variables that were set in the base image you selected will carry over to your new container image automatically, so you won't need to set those yourself unless you want to change them. For example, the definition files that use the `freesurfer/freesurfer:7.3.2` Docker container as a base image will already have the `FREESURFER_HOME` and other FreeSurfer-related environment variables set, so you will not need to set those. But if you are installing FreeSurfer "from scratch" in a container that uses a plain operating system based image, you will need to set those environment variables in your definition file.

On most operating systems, the `PATH` environment variable will be set by default. The `PATH` variable is a list of absolute paths to directories, with no spaces, with each item in the list separated by the `:` character. When you run a command-line program in the command line the system looks through each of those directories listed in the PATH environment variable to find that program. If it can't find a match in those folders, you see an error. 

One of the steps when installing FSL into the container image is to add the full location of the `bin` directory in the FSL program folder onto the `PATH` variable, by appending to the existing `$PATH` variable. 
In the Apptainer environment block you would do this by adding this line in the `%environment` section:
```
export PATH=/usr/local/fsl/bin:$PATH
```

and in a Dockerfile you would add this line:
```
ENV PATH /usr/local/fsl/bin:$PATH
```

After that runs, this means that any program that is located in `/usr/local/fsl/bin` will be accessible from just typing that program name rather than the whole location, so you can type `fslmaths` instead of `/usr/local/fsl/bin/fslmaths` and the container will know what you're talking about.

## Add program install commands

The main installation steps of any programs you need will happen in the %post section (for Apptainer) or using `RUN` instruction steps (for Docker). For Docker, you will add `RUN` before each of your commands, like this:

```
RUN [command1]
RUN [command2]
RUN [command3]
```

and in Apptainer, you will have a section in your definition file for program commands, starting with the text `%post` and with an indented set of commands under it, like this:

```
%post
    [command1]
    [command2]
    [command3]
```

The next sections will describe some types of commands you might need to include as part of your container setup.

### Using operating system package managers

If your run steps involve downloading program files and you chose a base container that does not have a downloading program like `curl` or `wget` installed, you will have to install that program as part of your install commands. This command would be the same as though you were installing one of those programs on a Linux machine of the operating system you are using for your container, which would most likely be through a Linux package manager. This is specific to the operating system of your base container.

#### If needed: Determining operating system of a base container image

The package manager your container uses will be dependent on the operating system of your base container. If you chose a base Docker container for a particular program and it wasn't clear what operating system it uses, you can you can quickly check by running that container in the command line with the `docker run` command and look at the `/etc/os-release` file with the `cat` command. Here is an example of checking the operating system used in the `freesurfer/freesurfer:7.3.2` Docker container.

```
docker run -t freesurfer/freesurfer:7.3.2 cat /etc/os-release
```

That command is using the `docker run` command to run a single container based on the image `freesurfer/freesurfer:7.3.2` and once that container is created, running only the command `cat /etc/os-release`, and then stopping the container.

In this case, the output looks something like this:
```
NAME="CentOS Stream"
VERSION="8"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="8"
PLATFORM_ID="platform:el8"
PRETTY_NAME="CentOS Stream 8"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:8"
HOME_URL="https://centos.org/"
BUG_REPORT_URL="https://bugzilla.redhat.com/"
REDHAT_SUPPORT_PRODUCT="Red Hat Enterprise Linux 8"
REDHAT_SUPPORT_PRODUCT_VERSION="CentOS Stream"
```

So now you know the `freesurfer/freesurfer:7.3.2` container image uses CentOS Stream 8 as its operating system, and can use CentOS 8 package manager commands to install any system programs you might need that weren't already there.

The equivalent command for a Apptainer image called `image.sif` would be:

```
apptainer exec image.sif cat /etc/os-release
```

Most Linux installations have the `/etc/os-release` file available in that location so you should be able to look at that file in many container images and see what operating system is in use.

---

You can use the operating system of your base image to look up which package manager is used by default. Then you would look up the commands of that particular package manager to install system programs. 

Ubuntu Linux uses `apt-get` as its default package manager, so in container image definition files that use `ubuntu:22.04` as a base container operating system, you would use `apt-get` commands to install system packages. As shown above, the `freesurfer/freesurfer:7.3.2` Docker image uses CentOS 8 Stream as the operating system, and CentOS includes the `yum` package manager, so you can use `yum` commands for installations. There might be multiple package managers available in an operating system, or you can use commands to install a different one if you prefer. Different operating systems and package managers have different packages and names available, so while there is a good amount of overlap for basic programs like `zip` and `wget`, some more advanced system libraries that are required for imaging programs might have different names or versions across package managers and you will need to look it up in the online package repository for the package manager you are using.

### Example installation steps using a package manager

Below are examples of the initial system package install steps in the Ubuntu-based containers. Since we are essentially installing packages in a new operating system, it's best to update the package repository list first with `apt-get -y update` and `apt-get -y upgrade`. The `-y` flag is included so the command prompt auto-selects "yes" rather than prompting you to enter something - when you are performing installations in a container image build, you will not be able to provide manual input or respond to prompts - every command must be entirely automated. The `&&` between the two commands chains them together into one line. This will shorten your definition file and reduce the number of build steps, but in that case, if one of the sub-steps fails, the entire line will fail, and you will need to figure out which sub-command failed and diagnose the issue. 

After the `update` and `upgrade` step we will install a list of packages with `apt-get -y install`. A couple of these are required for FSL. Some utilities like `tar`, `zip`, and `unzip` will be used for our install steps, or might be used in our custom workflow script e.g. if we are zipping up files or un-gzipping NIFTI files.

In Apptainer, those first commands go in the %post section:

```
%post
    apt-get -y update && apt-get -y upgrade
    apt-get -y install bc git openblas tar wget curl zip unzip python3
```

Here is the equivalent set of commands for a Dockerfile:

```
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install bc git openblas tar wget curl zip unzip python3
```

### Downloading external program files from a URL

Once you have the system packages in your container image updated, you can move on to running other program installations you need. Some program installations are relatively simple - you can just download a zip file and unzip it. Here are example lines on how that would happen in Apptainer %post section:

```
%post
    wget https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.3.2/freesurfer-linux-ubuntu22_amd64-7.3.2.tar.gz -O fs.tar.gz
    tar --no-same-owner -xzvf fs.tar.gz
    mv freesurfer /usr/local
    rm fs.tar.gz
```

First the `wget` command you just installed is used to get the zip file from the URL and save it as the file `fs.tar.gz`. Then the `tar` command is used to unzip the file. This command as written puts the unzipped output folder at the same location this command is run from. The output is a folder called `freesurfer` with the program output, that you can then move with `mv` to the destination you want (in this case `/usr/local`). Then the `rm` command removes the original `fs.tar.gz` file to decrease the size of the container image.

Here are the equivalent lines for a Dockerfile:
```
RUN wget https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.3.2/freesurfer-linux-ubuntu22_amd64-7.3.2.tar.gz -O fs.tar.gz
RUN tar --no-same-owner -xzvf fs.tar.gz
RUN mv freesurfer /usr/local
RUN rm fs.tar.gz
```

These lines are in the example Docker and Apptainer definition files but the tar line includes some `exclude` options to exclude certain sub-folders.

### Running a script

For other installations you may need to run commands like installer scripts or configuration setup scripts. As long as the script doesn't require user interaction when it runs, then you'll just want to make sure that:

- You have an earlier step to get the script file into the container
- You have an earlier step that installs any program or programming language (like Python) needed to run the script

Then you can add the exact command needed to call the installation script, either after a `RUN` instruction for a Dockerfile, or in the `%post` section for a Apptainer definition file.

For the example of the FSL installer script, it runs on Python, so the earlier package manager installation steps include `python3` as a software that will be installed. To get the script into the container, I could use Docker `COPY` or a line in Apptainer's `%files` section to copy the file into the container image, or in this case I can also use Docker `RUN` or a line in Apptainer's `%post` section to use wget to download it from a URL. Once the script is in the container, and I know where it is located, I can add the command I would use to install the program on a local computer, with a `RUN` instruction for a Dockerfile:

```
RUN python3 fslinstaller.py -d /usr/local/fsl --fslversion 6.0.4
```

Or from the %post section Apptainer for Apptainer:
```
%post
    python3 fslinstaller.py -d /usr/local/fsl --fslversion 6.0.4
```

----

[image-definition-files/example-freesurfer_base_image]: https://github.com/sarahkeefe/containerizing-neuroimaging-workflows/tree/main/image-definition-files/example-freesurfer_base_image
[image-definition-files/example-ubuntu_base_image]: https://github.com/sarahkeefe/containerizing-neuroimaging-workflows/tree/main/image-definition-files/example-ubuntu_base_image
[Apptainer documentation on Definition Files]: https://apptainer.org/docs/user/main/definition_files.html
[Docker Dockerfile documentation]: https://docs.docker.com/build/building/packaging/