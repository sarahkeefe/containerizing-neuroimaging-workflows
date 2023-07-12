---
layout: default
title: Finalize your command list
parent: Convert workflow for containerized use
nav_order: 1
---

# Finalize your list of workflow commands

The first step is to solidify the workflow you will be containerizing. The idea is to set up a structured order of your commands that is what you and other users of your container will be running exactly, every time you run it.

## Set up a text file with your list of commands

Set up a text file, `workflow_commands.txt`, to organize your commands and plan what steps you want to do in which order. 

Below is the example list of DTI preprocessing commands that this tutorial will be using as the command list.

1. fslroi on a DTI scan file called "dwi.nii.gz", creating an output called "nodif.nii.gz"
```
fslroi dwi.nii.gz nodif.nii.gz 0 1
```

2. FSL Brain Extraction Tool on "nodif.nii.gz"
```
bet nodif.nii.gz nodif_brain.nii.gz -f 0.25 -g 0 -m
```

3. eddy_correct on the "dwi.nii.gz" scan file
```
eddy_correct dwi.nii.gz eddy_corrected.nii.gz 0
```

4. dtifit on the eddy_corrected output plus the bet-extracted nodif file, incorporating the bvec and bval information for the original DTI scan.
```
dtifit -k eddy_corrected.nii.gz -m nodif_brain.nii.gz -r dwi.bvec -b dwi.bval -o dtidata.nii.gz
```

It can be helpful to add some comments in your `workflow_commands.txt` file about what each step does. 

Our example `workflow_commands.txt` file for this step can be seen in the file `step1-workflow_commands_initial.txt`.