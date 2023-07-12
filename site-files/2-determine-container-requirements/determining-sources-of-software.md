---
layout: default
title: Determine sources of software
parent: Determine container requirements
nav_order: 2
---

# Determining sources of your required software

A container definition file is like installing a fresh set of programs on a new operating system. You'll install things by using package management tools in the operating system you are using, by downloading program files from existing URLs or repositories, and by copying in files that you have locally that you need exact copies of. 

## Obtaining software programs

When building your container image, you will need to specify install steps as though you were installing these programs on a new computer. This means you'll need to have a source where each piece of software comes from. 

### Cloud download

Container definition files can download program files from URLs on the internet using command-line programs like wget and curl. If you're installing a program from a URL you'll need to get the URL but also determine what to do after the files are downloaded. If the program is in a compressed file that needs to be unzipped, your definition file will need to include the commands for the unzip steps and any subsequent installation or configuration steps that might be needed.

### Linux package manager commands

Definition files can also include commands from package managers. By default the package managers available will be the ones that come with the operating system of your base container. You can also add steps to install other package managers or installers as part of your container definition file. Then in subsequent parts of the definition file you could then use commands that use that package manager.

## Incorporating custom local files

You will also most likely have custom scripts, personal license files, or files specific to your group's work that you need to include, but won't want to make accessible via a URL or package manager repository. One example will be the script file you tested earlier. Files that aren't accessible via URL or package manager can be copied in directly in the container definition file. You will want to make sure you have a local copy of them available, and for simplicity have the files in the same folder as your container image definition file.

## MATLAB considerations

If you are working with MATLAB code as part of your workflow, you will have to deal with an extra set of challenges. Since MATLAB is an externally licensed program, you won't be able to incorporate your MATLAB code as-is into your container and have it be usable to other users regardless of whether they have a MATLAB license. In order to seamlessly integrate MATLAB scripts into a containerized workflow, you will need to compile it into a "standalone" program file that can be run with the MATLAB runtime program. This requires access to the MATLAB compiler toolbox for the compilation process. Once the code has been compiled into a standalone program, it can be copied in as part of a container image build and used as long as the free MATLAB runtime program for the appropriate MATLAB version is also incorporated into the build. I will hopefully be writing up a brief instruction set on this process in the future. 