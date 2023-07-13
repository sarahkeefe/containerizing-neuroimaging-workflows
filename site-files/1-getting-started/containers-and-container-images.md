---
layout: default
title: Containers and container images
parent: Getting started
nav_order: 3
---

# Container images and containers

The process of containerizing your workflow can be referred to as "building a container image". A "container image" differs from a "container", and both differ from a "container image definition file". 

## Container image definition file

A "container image definition file" is a text file used to build a container image. 

In Docker, the definition file can be in a text file named `Dockerfile` for use with the `docker build` command, or in YML/.yml format for use with `docker-compose`. This tutorial will cover Dockerfile syntax and `docker build`.

In Apptainer, an image definition file or "def file" is a text-based file that uses Apptainer image definition file syntax.

In either platform, the container definition file contains instructions on how to build a container image that contains the programs and files you need to run your workflow. Instructions include specification of the operating system version to use in the container image, commands to download and install software and libraries that you need, commands to copy in your own custom files, and definitions of any environment variables that you want to be set any time your container image is run as a container.

## Container image

A container image is what gets created when you run a container platform build command with your image definition file as input. The container image is like a template for creating new processes, or containers, exactly to your specifications.

In Docker, a definition file in Dockerfile format gets built using the `docker build` command, and a definition file in `.yml` format gets built using `docker-compose`. In Apptainer an image gets built using `apptainer build`. 

When you run a build command, an image file gets created in a location dependent on your platform choice and configuration options. You can then use the image file to run containers.

## Containers

A container is a process created from a container image. In Docker you would run a container from an image with `docker run` and in Apptainer you would use `apptainer exec`. There is also a very similar `apptainer run` for running specified commands, but I will use `apptainer exec` in the examples. 

When you run one of these "run commands" using the name of your image as input, the containerization platform will use the image you specify to create a new container from it. 

The `docker run -it` or `apptainer shell` commands can run a container from an image interactively, which means you can use it as a virtual command-line system with your software installed. Most of this tutorial will go over run commands that specify an image, create a container from it, and send a single command. Then the new container will run that single command you specify and then exit the container. 

The second way is what this tutorial will use for setting up a custom workflow. The main steps will be:
- First you will set up a custom script for your workflow actions
- Then you will build your container image and include your custom script in it
- Then you will set up a run command to use your container image to create a new container and send it a command to run your custom script.

