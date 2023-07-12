---
layout: default
title: Build an Apptainer image
parent: Build the container image
nav_order: 2
---

# Build an Apptainer image from an Apptainer definition file

## Simple build command format

The basic Apptainer build command is in this format:

```
apptainer build image_filename.sif apptainer_definition_file.txt
```

For Apptainer, you will need to add in the `--fakeroot` flag to perform the build unless you are on a system where you have administrative/sudo permissions.
Here is my example build command with the definition file from this tutorial:

```
apptainer build --fakeroot container_tutorial_1_0-dev.sif apptainer_def.txt
```

This will build an Apptainer container image file with the name "container_tutorial_1_0-dev". The last parameter, apptainer_def_file.txt, is the filename of your container image definition file.

### Saving information for future troubleshooting

For Apptainer it is helpful to set some environment variables to tell the Apptainer engine where to store intermediate and log files. 
- `APPTAINER_CACHEDIR` specifies where cache files should be stored, and should be set to an absolute directory path (The full path to a directory of your choice, starting with `/`). 
- `APPTAINER_TMPDIR` specifies where temporary build files should go and should also be set to an absolute folder path. 
If a build fails, the files stored in these directories can be helpful to refer to when troubleshooting. 

```
export APPTAINER_CACHEDIR=`pwd`/buildcache
export APPTAINER_TMPDIR=/tmp
```

It can also be helpful to add the `--no-cleanup flag` to keep temporary files around in case you need to do any troubleshooting, although this will cause your builds to take up more space on your machine.

Here is the example build command with the --no-cleanup flag included:

```
apptainer build --fakeroot --no-cleanup container_tutorial_1_0-dev.sif apptainer_def.txt
```

More details on the Apptainer build command can be found in the [Apptainer build command documentation].


## Running the build command

To run your build command, make sure your current working directory is the folder that contains your Apptainer definition file and your custom workflow script file along with any other files that you need to copy into your container image. In this example we are using the folder `container_image_files` that we set up earlier. 

Use `pwd` to check your location - you should be in the `containerization_tutorial/container_image_files` folder.

First set the environment varibles for the cache and temporary directories in case you need them:
```
export APPTAINER_CACHEDIR=`pwd`/buildcache
export APPTAINER_TMPDIR=/tmp
```

From that folder, run your Apptainer build command:

```
apptainer build --fakeroot --no-cleanup container_tutorial_1_0-dev.sif apptainer_def.txt
```

The Apptainer engine will go through the build steps in your definition file and run them one by one. Since the main tutorial definition file starts with 
```
Bootstrap: docker
From: freesurfer/freesurfer:7.3.2
``` 

The first step will pull the Docker image tagged freesurfer/freesurfer:7.3.2 and use that as the base of building this Apptainer image.

After that it will proceed through the steps in each section of the definition file.

Since this is hopefully a working tutorial, the build should complete successfully and show a success message at the end:

![successful-apptainer-build](images/successful-apptainer-build.png){:class="img-responsive"}

If the build does not complete, you should see an error message that indicates that the build failed on a particular step. 

## If your build succeeded: Check that your image built correctly

After a successful build in Apptainer, you should have a file of .sif format in your build directory. In our build example command the filename would be "container_tutorial_1_0-dev.sif".

Once your `apptainer build` command completes, you can confirm that you have an image file by listing the files in your current directory:

```
ls
```

If your build completed, you will see the filename of the image you built in the list, like this:

![successful-apptainer-image-list](images/successful-apptainer-image-list.png){:class="img-responsive"}

## If your build failed: Troubleshoot, fix, and rebuild

If your build failed, proceed to the [Troubleshooting and rebuilding step] of this tutorial to get some tips on how to investigate build errors and fix them. You will need to make changes to your container image definition file and rerun the build command until you can get a build to complete successfully.

----
[Apptainer build command documentation]: https://apptainer.org/docs/user/latest/build_a_container.html
[Troubleshooting and rebuilding step]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/5-build-container-image/troubleshooting-and-rebuilding