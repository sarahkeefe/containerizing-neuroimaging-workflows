---
layout: default
title: Sharing container images
parent: Use and share your image
nav_order: 2
---

# Sharing container images

## Sharing an image vs. sharing container files

When you share your container image with others, you can technically send them a set of your input files along with your container definition text file, and give them instructions on how to use `docker build` or `apptainer build` to build it. But if your definition file steps include downloading files from the internet to install in your container, there is a chance that install steps may fail if URLs change. For maximum reproducibility, you would want to build your container image yourself, and then share the image itself with others who are using the same platform. 

## Docker: Tag and push to Docker Hub

One way to share your image is in the public Docker Hub repository. This means that anyone in the world will be able to pull your image onto their machine and use it, so make sure you are ready to share it widely. 

First create an account on [Docker Hub] and choose a username.

In your command line that has the image built that you would like to share, run the command to list your built Docker images to be sure the one you want to share is listed:
```
docker image ls
```

You should see a list with your recently built image in it, like this:

![docker-sharing-image-ls](images/docker-sharing-image-ls.png){:class="img-responsive"}

The image we have in the example is `container_tutorial:1.0-dev`. What you are going to do is **re-tag** that image with a new tag that will enable it to be pushed to Docker Hub under your username. The original tag `container_tutorial:1.0-dev` won't be overwritten, the image will still be tagged with that tag, but a new image tag will be added on and appear in your `docker image ls` image list.

To add a tag for Docker Hub to your existing image, the command is formatted like this:
```
docker tag original_image:original_version your_docker_hub_username/new_image:new_version
```
where `original_image:original_version` is the local image and version tag, and the `your_docker_hub_username/new_image:new_version` is the new tag you want to add. The new tag incorporates your Docker Hub username in front of it, which means that it can be pushed to Docker Hub under your user account.

So in our example, I am going to push the container tutorial image to my Docker Hub account. My username is `sarahkeefe` and I will use the same image tag as I did locally, but update the version from `1.0-dev` to `1.0` because I am done developing the image and want to release the 1.0 version. (The version tag can be anything you want - using `1.0-dev` while an image is in development, then changing to `1.0` when you make it public is my preferred convention). 

Here is my tag command:
```
docker tag container_tutorial:1.0-dev sarahkeefe/container_tutorial:1.0
```
Once you run that, you can then rerun `docker image ls` and you'll see a new entry in your list, with the same image ID, but a different tag and version from the tag command I just ran:

![docker-sharing-image-ls-new-tag](images/docker-sharing-image-ls-new-tag.png){:class="img-responsive"}

Now that your image is tagged with your Docker Hub username, you can push that image to Docker Hub. Log in to Docker Hub via the command line by typing `docker login` and entering your username and password. It should look like the output below:

![docker-sharing-docker-login](images/docker-sharing-docker-login.png){:class="img-responsive"}

Once you are logged in, you can use the `docker push` command on your newly re-tagged image to push your image to your Docker Hub account.

```
docker push sarahkeefe/container_tutorial:1.0
```

You'll see the image layers being pushed to Docker Hub:

![docker-sharing-docker-push](images/docker-sharing-docker-push.png){:class="img-responsive"}

And when it's done, you should see that pushed image appear publicly on the Docker Hub repository. Users can then pull your image with 
```
docker pull your_docker_hub_username/container_tutorial:1.0
``` 

Other users would just need to replace the image tag `your_docker_hub_username/container_tutorial:1.0` with your Docker Hub username and whatever tag you just pushed to Docker Hub.

Other non-centralized or private Docker container image registries can be set up. Your institution or collaborators may have one set up for you to use. Refer to documentation from any private registry you work with to determine what tagging format and authentication methods are needed for you to push your container to that registry.

## Docker: Export image to a file

If you want to save and share your image in a way other than via Docker Hub, you can use `docker save` to create a compressed archive. Here is a way to save your image tag `container_tutorial:1.0-dev` as a .tar file:

```
docker save --output my_image_in_a_file.tar container_tutorial:1.0-dev
```
You can replace `my_image_in_a_file.tar` with any filename you want to use as a filename for your saved image. You can use `gzip` to compress your image file and make the final file size smaller:

```
gzip my_image_in_a_file.tar
```

This will result in a file `my_image_in_a_file.tar.gz`. When you share that file with others, they can un-zip it with `gunzip` first:
```
gunzip my_image_in_a_file.tar.gz
```

Then they will have the unzipped .tar file `my_image_in_a_file.tar`. They can load the .tar file into their own Docker Engine installation with `docker load` like this:

```
docker load --input my_image_in_a_file.tar
```

By default the tag will be the same as the tag you used `docker save` with, so in this case after they run `docker load`, when they run the next `docker image ls` they should see an image with tag `container_tutorial:1.0-dev` in their image list. Then they can use that image the same way you did.

## Apptainer: Sharing your `.sif` image file

By default Apptainer will store built images in files with a `.sif` file extension. These files can be shared as individual image files with other users, who can then use them the same way you would. 

Apptainer also offers the ability to push to many decentralized "Library API registries" that work like the public Docker Hub - users can push and pull `.sif` files to these registries via their URLs.

Your institution or collaborators may have an Apptainer registry set up for you to use. First you'll want to create an account on the particular registry you wish to use, then use `apptainer remote` on your machine to log in to that registry with your username which will add it as a **remote endpoint** for you to push container images to. 

```
apptainer remote login --username your_registry_username library://url/of/registry
```

You would replace `your_registry_username` with the username you use to authenticate to the Apptainer registry, and replace `library://url/of/registry` with the registry path according to that registry's URL and documentation. 

More details about setting up Apptainer remote endpoints can be found in the [Apptainer remote endpoint documentation].

Once you are authenticated to the remote registry, you would then use the `apptainer push` command to push your .sif file to the remote endpoint, something like this, depending on your registry's URL and organization structure:
```
apptainer push container_tutorial_1_0-dev.sif library://url/of/registry/your_registry_username/container_tutorial:1.0
```
The end of the specific registry URL you push to is a tag for the container, similar to tagging a Docker image for Docker Hub with your username

More details on pushing containers to Apptainer library registries can be found in the [Apptainer library API documentation].

----
[Docker Hub]: https://hub.docker.com
[Apptainer remote endpoint documentation]: https://apptainer.org/docs/user/latest/endpoint.html#overview
[Apptainer library API documentation]: https://apptainer.org/docs/user/latest/endpoint.html#overview