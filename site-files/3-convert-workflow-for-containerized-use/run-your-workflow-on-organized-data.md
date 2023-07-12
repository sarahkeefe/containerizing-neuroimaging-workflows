---
layout: default
title: Run your workflow on organized data
parent: Convert workflow for containerized use
nav_order: 2
---

# Run your workflow commands on organized data.

To begin converting your workflow steps into a single script for containerized use, you'll want to test the commands in order on structured data.

## Organize your input data and create an output folder.

In the [Using the tutorial files] section earlier, you should have set up a copy of the tutorial example script files and data files. Use this folder structure to test the workflow commands.

Use `cd` to get into your `containerization_tutorial` folder.

Your folder tree when you are in that folder should look something like this:
```
├── container_image_files
│     ├── apptainer_def.txt
│     ├── Dockerfile
│     ├── license.txt
│     ├── parc
│     │     └── Schaefer2018_200Parcels_7Networks_order_FSLMNI152_2mm.nii.gz
│     └── run_workflow.sh
├── convert-workflow-steps
│     ├── step1-workflow_commands_initial.txt
│     ├── step2-workflow_commands_organized.txt
│     ├── step3-initial_workflow_script.sh
│     ├── step4-script_with_hardcoded_inputs.sh
│     └── step5-script_with_cl_inputs.sh
├── freesurfers
│     ├── containerization_tutorial_fs_to_download.csv
│     ├── download_oasis_freesurfer.sh
│     └── OAS30001_MR_d3132
│         ├── label
│         │     └── [FreeSurfer output files]
│         ├── mri
│         │     └── [FreeSurfer output files]
│         ├── scripts
│         │     └── [FreeSurfer output files]
│         ├── stats
│         │     └── [FreeSurfer output files]
│         ├── surf
│         │     └── [FreeSurfer output files]
│         └── tmp
│             └── [FreeSurfer output files]
├── output
└── scans
    ├── containerization_tutorial_scans_to_download.csv
    ├── download_oasis_scans.sh
    └── OAS30001_MR_d3132
        ├── anat1
        │     └── [scan files]
        ├── dwi1
        │     └── [scan files]
        └── [other scan folders]
```

index/readme files, specific Freesurfer output files, and scan files have been omitted from this representation, but your general folder structure should be the same but contain those extra files.

You are starting with 3 folders in this working directory: 
- `freesurfers` containing FreeSurfer output folders
- `scans` containing folders of imaging scan files for each scan session (in this case downloaded from OASIS-3 in BIDS format), and 
- an empty directory called `output` for your output to be saved into. 

This input is specific to the example workflow being demonstrated, but for your future workflow customization you can adjust this to be more specific to what data you are testing with and how your data is stored on your system.

You could have multiple FreeSurfer output folders in the `freesurfers` directory, and you could have multiple scan session folders in the `scans` directory, and more scan type folders in the `scans/OAS30001_MR_d3132` directory (e.g. have an "anat1" or "dwi2" scan in scans/OAS30001_MR_d3132). But for simplicity in this tutorial this tree only shows the data we will be using.

## Look at the list of commands

Open the file `convert-workflow-steps/step1-workflow_commands_initial.txt` from the tutorial Github repository in a text editor. It can be helpful to have a command line terminal open while also using a GUI text editor such as Sublime Text or Notepad++. You can also do everything via the terminal and use a terminal-based text editor instead.

The `convert-workflow-steps/step1-workflow_commands_initial.txt` file is a list of commands that we will be converting into a script that will be usable within a container on more generalized data. 

We will be going through the workflow commands one at a time and updating them to run on our organized data. 

### How to update input file paths

We'll update each command as though it would be run from within the `containerization_tutorial` folder, changing the file paths so it can find the data files - scans and FreeSurfer files- based on the folder tree you have (shown above). Update it to use the relative paths to each file in the organized data subfolders relative to your working directory location in `containerization_tutorial`. For example, if you are trying to use the `sub-OAS30001_sess-d3132_run-01_dwi.nii.gz` file with your command, the relative path to that file from within the `containerization_tutorial` folder would be

```
scans/OAS30001_MR_d3132/dwi1/sub-OAS30001_sess-d3132_run-01_dwi.nii.gz
```

Since that file is located in the `scans` folder tree within `containerization_tutorial`.

### How to update output file names and paths

In addition to updating to point to the correct input files, update the script to place any ouptut files into the `output` folder. In any place your command creates output files, change the output filenames in your command steps to make sure each file gets saved to the empty `output` folder that you have within the `containerization_tutorial` folder. For example, if you are creating a file called `nodif.nii.gz`, the output file path should be

```
output/nodif.nii.gz
```

### Using meaningful file names

In this tutorial I am going to suggest giving any output files you create meaningful names that incorporate the label of the scan session you are using. This will reduce any confusion of having multiple output files of the same name and not knowing which session they belong to. We will also be making sure that separate sessions have different output folders, but this is an additional data organization measure I like to take.

So for example, when saving your `nodif.nii.gz` file to the output folder, incorporate the scan session label like this:

```
output/OAS30001_MR_d3132_nodif.nii.gz
```

You will be going through the workflow command list and update all references to the input and output files in each command. 


## Adapt the first command to work with your organized input data and output folder.

Below is an example of how to update the first command.

This is the first command in our `convert-workflow/step1-workflow_commands_initial.txt` command list file:

```
fslroi dwi.nii.gz nodif.nii.gz 0 1
```

Since the command runs on our DTI scan file, and we want the output to go into the `output` folder and be named something meaningful for our particular scan session, the updated command would be:

```
fslroi scans/OAS30001_MR_d3132/dwi1/sub-OAS30001_sess-d3132_run-01_dwi.nii.gz output/OAS30001_MR_d3132_nodif.nii.gz 0 1
```

Once you have your first command updated in your text editor, return to the command line and ensure that your current working directory is `containerization_tutorial`:

```
pwd
```

Then copy the exact updated command from your text file, paste it into the command line, and press Enter. 

If you set it up correctly, the first command in your workflow should use the correct files from your file structure and place any output files in the `output` folder. Ensure that this works the way you expected it to and places the correctly named files in the `output` folder. If you run into any issues, delete everything from the `output` folder, make any changes to the command and re-try the command until it works as expected.

Once the files are correctly used, saved, and named, move on to the next command.

## Adapt the second command to work with the output of the first command.

Once you have the first command successfully updated to work with the organized file structure, work on the next command in the workflow command list. Adjust the next command so it uses the file structure and file naming from the output of your first command. If you saved files to the `output` folder with the first command and then need to use those files as input for the next command, update the file paths in your second command to reflect that.

Here is our second command in our example workflow before updating:

```
bet nodif.nii.gz nodif_brain.nii.gz -f 0.25 -g 0 -m
```

This is running FSL BET on the `nodif.nii.gz` output file from the previous step.

The updated version of our first command saved our nodif output file saved to `output/OAS30001_MR_d3132_nodif.nii.gz`. So we want to update our second (`bet`) command to use the nodif file where we saved it. We also want to save the output file in the `output` folder as well so we don't add new files to our source data. We will update our second command like this:

```
bet output/OAS30001_MR_d3132_nodif.nii.gz output/OAS30001_MR_d3132_nodif_brain.nii.gz -f 0.25 -g 0 -m
```

After updating the second command, test running it from `containerization_tutorial` as you did with the previous one. If your second command removes or alters files from the prior command in an unexpected way, that is a mistake, and you'll need to start over and re-set your workflow output. 

To start over, remove everything from your `output` folder:
```
rm -r output/*
```
Then do-over the parts of the workflow you have done so far by rerunning the first command on the original output data. Then try to correct the update to the second command and re-try testing the second command with those output files from command 1. 

If your second command goes wrong again, start over again and re-attempt another fix of command 2. When command 2 correctly generates the files and sends the output to the correct place, update your text editor file with the corrected command 2 and save it. Then move on to command 3 and perform the same modification, testing, and troubleshooting steps.


## Update the remaining steps of your workflow to run in with the output from the prior step.

Continue to update the rest of your workflow commands in workflow_commands.txt in this way, with each step using the data from the subsequent step, putting any new data in the output folder rather than modifying or adding to your source data folders, and naming the output files in a meaningful way. Save your changes to workflow_commands.txt as you go along. 

As you test, make sure the commands are being run in order without any manual intervention between the steps (like manual file copying or moving by a human). If you need to add in any extra steps such as copying files, include those steps as commands to be run as part of the workflow. For example, if you need to copy a file to another filename between workflow steps, include a "cp" command in your workflow where that needs to be done.


## Re-set your output directory and run a single test of all steps in order.

When you have worked through testing and updating each command in `convert-workflow-steps/step1-workflow_commands_initial.txt` and expect that each command will work with the previous command's output, do a final test of all the steps in order to be sure. Remove everything in the output folder:
```
rm -r output/*
```

Then run each line from your updated `convert-workflow-steps/step1-workflow_commands_initial.txt` file and ensure you can run the lines in order with no intervention.

When you are done, you should be able to:
- Start from your `containerization_tutorial` directory
- Start with only the source files in their organized structure 
- Start with an empty output folder
- Run each command in your updated version of `convert-workflow-steps/step1-workflow_commands_initial.txt` in the command line one-by-one, exactly as you have it saved, and get to the next step without needing to do any manual file changes
- Have generated files from your entire workflow after you have run all the updated commands in `convert-workflow-steps/step1-workflow_commands_initial.txt`

The files in the `output` folder should be what you would expect to get when you run your workflow.
Once you have this working, move on to the next step.

## Continue with the tutorial

For this tutorial example, your updated `convert-workflow-steps/step1-workflow_commands_initial.txt` file after this process should look similar to `convert-workflow-steps/step2-workflow_commands_organized.txt`. The next step of the tutorial will start with the step 2 file.

----

[Using the tutorial files]:https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/1-getting-started/using-the-tutorial-files.html
[Github file raw view]: https://raw.githubusercontent.com/sarahkeefe/containerizing-neuroimaging-workflows/main/convert-workflow/step1-workflow_commands_initial.txt