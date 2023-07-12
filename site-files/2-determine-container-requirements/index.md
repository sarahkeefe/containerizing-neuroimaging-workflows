---
layout: default
title: Determine container requirements
nav_order: 3
has_children: true
---

# Determining requirements for your container

This section will give some suggestions on determining what needs to be included in your containerized workflow, and describes some decisions to be made before starting the process.

[Determine the structure of your workflow] will go over organizing the commands that you need to run in order on your data.

[Determine sources of software] will help you consider how particular programs used in your command list could be incorporated into your container image.

[Choosing a base image] will go over some considerations for when you choose whether to build a container image from a bare-bones operating system container, or add your build steps on top of an existing container that might have some of your software needs in it already.

----
[Determine the structure of your workflow]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/2-determine-container-requirements/determine-the-structure-of-your-workflow
[Determine sources of software]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/2-determine-container-requirements/determine-programs-needed
[Choosing a base image]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/2-determine-container-requirements/choosing-a-base-image