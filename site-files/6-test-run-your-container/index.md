---
layout: default
title: Test run your container
nav_order: 7
has_children: true
---

# Test run your container

Once you have a usable container image, the next step is to try out a test run of your containerized workflow using the same data you used to test each step of your workflow script. 

This requires setting up a "run command" which will run one instance of your container on your test data.

Instead of jumping right in to set up a run command for your custom workflow script, these sections will walk through some example run commands first to demonstrate setting up the command to send to the container, determine where script and program files appear within your running container, and "mounting" your local data files so the running instance of the container can access them.

The [Docker run command setup] section will go over this process for Docker container images.

The [Apptainer exec command setup] section will go over this process for Apptainer container images.

The [Troubleshooting container run issues] section will give some tips on troubleshooting and identifying issues with your run command, and determining whether the issue might be with your run command or your container itself.

----
[Docker run command setup]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/6-test-run-your-container/docker-run-command-setup
[Apptainer exec command setup]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/6-test-run-your-container/apptainer-exec-command-setup
[Troubleshooting container run issues]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/6-test-run-your-container/troubleshooting-container-run-issues