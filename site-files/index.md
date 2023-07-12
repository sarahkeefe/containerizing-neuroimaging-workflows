---
title: Containerization Tutorial Home
layout: home
nav_order: 1
---

# Neuroimaging Containerization Tutorial Documentation

This is the documentation for "Containerizing neuroimaging workflows for scalable and reproducible analyses". This is part of a poster presentation[^1] shown at the Alzheimer's Association International Conference in July 2023.

## Documentation overview

This tutorial provides a series of steps and accompanying scripts and examples to walk you through containerizing an example DTI image processing workflow that incorporates FSL and FreeSurfer. If you are aiming to containerize your own custom neuroimaging workflow you use regularly, it could be helpful to walk through the tutorial steps with the provided scripts first, and then follow the steps again with your custom workflow once you are familiar with the process.

Here is an overview of the tutorial sections:

1. [Getting started]. This section will go over how to use the materials in this tutorial, provide some suggestions to help you decide whether you want to use Singularity/Apptainer or Docker, and briefly clarifies some terminology that will be used in the rest of the tutorial.

2. [Determine container requirements]. This section provides guidance on determining what needs to be included in your containerized workflow, and describes some decisions to be made before starting the process.

3. [Convert workflow for containerized use]. This section walks through the process of converting a set of one-line command-line commands, that you would normally run one-by-one, into a script that can be generalized and used in a containerized workflow across a variety of datasets.

4. [Create image definition file]. This section goes over the steps of setting up a definition file for building a Docker or Singularity/Apptainer container image. The definition file will be used to "build" the container image in later sections.

5. [Build the container image]. This section provides example build commands to use when building an image from your image definition file. It also includes some guidance on troubleshooting errors and re-building as needed to get you to a completed build of you container image.

6. [Test run your container]. This section provides details on how to use `docker run` or `apptainer exec`/`singularity exec` commands to try running your container based on your newly built image. It starts with running simple commands with your image and works up to running your customized workflow script within the container.

7. [Check container output] provides some tips on checking whether your container ran successfully and whether the output files from your initial container run are identical to the results from your initial non-containerized test runs of your workflow.

8. [Use and share your image]. This section includes two sub-sections focusing on utilizing your container image for reproducible research. [Batch running containers] provides details and examples of how to run multiple instances of your container at once. [Sharing container images] gives details on how to share your container image with others and push your container image to the cloud for public use. 

----

[^1]: [Link to poster presentation can be found in the Alzheimer's Association journal publication from AAIC 2023](https://alz.org).

[Getting started]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/1-getting-started
[Determine container requirements]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/2-determine-container-requirements
[Convert workflow for containerized use]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/3-convert-workflow-for-containerized-use
[Create image definition file]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/4-create-image-definition-file
[Build the container image]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/5-build-the-container-image
[Test run your container]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/6-test-run-your-container
[Check container output]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/7-check-container-output
[Use and share your image]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/8-use-and-share-your-image
