---
layout: default
title: Build a Docker image
parent: Build the container image
nav_order: 1
---

# Build a Docker image from a Dockerfile

## Simple build command format

The basic Docker build command format is as follows:

```
docker build -t [container_tag]:[container_version_number] .
```

This command expects to find a container definition file named Dockerfile and any input files that get used with a "COPY" instruction in the folder you run the command from. When running the build command, include a tag name and version for your image. The Docker tag name is in the format `dockerhub_username/image_name` and the version number can be a number or string.

`dockerhub_username/` is only needed if you are planning to push your image to Docker hub right away. You can always re-tag it later. For now I will use the local tag name "container_tutorial:1.0-dev"

For this example I will run this build command with our local tag name:

```
docker build -t container_tutorial:1.0-dev .
```

The build command will look for a file named "Dockerfile" in your current working folder which you specify with the dot `.` at the end. Docker will expect every file that you copy with a COPY instruction to be located in the folder you run this command from. If neither of those things is true you will get an error and the build won't work.

If you want to run your build command on a Dockerfile with a different filename, for example "Dockerfile_test1", you can use the `-f` flag and send the name of your alternative Dockerfile like this:

```
docker build -t container_tutorial:1.0-dev -f Dockerfile_test1 .
```

More options for the Docker build command can be found in the [Docker build command documentation].


## Running the build command

To run your build command, make sure your current working directory is the folder that contains your Dockerfile and custom workflow script file along with any other files that you are copying into your container image. In this example we are using the folder `container_image_files` that we set up earlier. 

Use `pwd` to check your location - you should be in the `containerization_tutorial/container_image_files` folder.

From that folder, run your Docker build command:

```
docker build -t container_tutorial:1.0-dev .
```

The Docker engine will go through the build steps in your Dockerfile and run them one by one. 

Since this is hopefully a working tutorial, the build should complete successfully and show a success message at the end:

![successful-docker-build](images/successful-docker-build.png){:class="img-responsive"}

If the build does not complete, you should see an error message that indicates that the build failed on a particular step. 

## If your build succeeded: Check that your image built correctly

Once your `docker build` command completes in Docker, run the Docker command that lists the images you have built on your machine:

```
docker image ls
```

If your build completed, you will see the tag of the image you built in the list, like this:

![successful-docker-image-list](images/successful-docker-image-list.png){:class="img-responsive"}

If you see a tag from your successful build but you also see a lot of images that have empty tags, these are most likely intermediate images from failed builds. You can run the prune command to clean up some of those untagged intermediate images:

```
docker system prune
```

## If your build failed: Troubleshoot, fix, and rebuild

If your build failed, proceed to the [Troubleshooting and rebuilding step] of this tutorial to get some tips on how to investigate build errors and fix them. You will need to make changes to your Dockerfile and rerun the build command until you can get a build to complete successfully.

----
[Docker build command documentation]: https://docs.docker.com/engine/reference/commandline/build/
[Troubleshooting and rebuilding step]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/5-build-container-image/troubleshooting-and-rebuilding