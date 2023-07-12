---
layout: default
title: Troubleshooting and rebuilding
parent: Build the container image
nav_order: 3
---

# Troubleshooting container image builds

## Troubleshooting issues with the build

Your build may fail on a particular step. The output of the container engine build process will end with a message saying which step it failed on and show the most recent commands it has run that didn't work. 

Docker builds will generally provide all log output to the console directly. Apptainer builds will point you towards a separate log file that might contain more useful information. Use this info to diagnose what might have gone wrong. Some potential issues might include:

- Problems with a download link for application files coming from the internet
- Problems with running programs that were expected on the default operating system but actually need specific installation, such as `zip`, `unzip`, or `tar` for compressed archives, or `curl` or `wget` if you have steps that are downloading files or running programs that are downloading files.
- When running initial package installations with package manager programs like `apt`, `dnf`, or `yum`, they may require initial cleanup or update command steps specific to your package manager program before running the install steps.
- You may accidentally include a command that expects user input. In that case the build will fail since there is not a straightforward way to send user input into a container build. You'll need to update the command to include a flag like `-y` which in some programs will allow a program to "assume yes" and run the command without requiring human input.
- You might run into problems installing a particular program like FSL without all dependencies appropriately met within the container. This requires adding build steps to make sure all those dependencies are present before the main program install step.

## Rebuilding

When you run into issues, modify your container definition file, save it, and then re-attempt the build command you were using until the container image build program can get past that particular step. Continue the troubleshooting and build attempt cycle until you are able to get the image build to complete successfully.