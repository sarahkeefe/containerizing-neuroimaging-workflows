---
layout: default
title: Convert workflow for containerized use
nav_order: 4
has_children: true
---

# Convert your workflow for containerized use

This section will step through the process of converting a set of command-line commands, that you would normally run one at a time, into a script that can be generalized and incorporated into a container image.

[Finalize your command list] will go over the example list of commands this tutorial will use and put the commands into a single text file to work with.

[Run your workflow on organized data] will cover setting up a test directory structure with an initial test dataset in it. Then it will go over how to use that setup to test your commands.

[Create a simple script file] will go over creating a script file that you can run from your test directory structure and produce the same outcome as running your commands one-by-one.

[Incorporate variables into your script] will look at starting to abstract away the inputs that are specific to your test dataset, and starting to generalize things for use on other data.

[Incorporate command-line inputs] will finish generalizing your script so it can run from a command-line command on any input data you point it to.

----
[Finalize your command list]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/3-convert-workflow-for-containerized-use/finalize-your-command-list
[Run your workflow on organized data]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/3-convert-workflow-for-containerized-use/run-your-workflow-on-organized-data
[Create a simple script file]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/3-convert-workflow-for-containerized-use/create-a-simple-script-file
[Incorporate variables into your script]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/3-convert-workflow-for-containerized-use/incorporate-variables-into-your-script
[Incorporate command-line inputs]: https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/3-convert-workflow-for-containerized-use/incorporate-command-line-inputs