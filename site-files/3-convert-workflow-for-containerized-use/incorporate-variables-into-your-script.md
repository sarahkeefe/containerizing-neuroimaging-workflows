---
layout: default
title: Incorporate variables into your script
parent: Convert workflow for containerized use
nav_order: 4
---

# Update your script file to use variables for input.

Once you are able to run your initial workflow script, the next step will be to start the steps that will make your workflow more generically usable across different input data. For each command in your script file, you will want to determine which pieces are specific to your data, and change that part of the command to use a variable instead. 

For more background on what we are doing with this step, here is a page with some [documentation and examples on using variables in bash scripting].

Open the file `convert-workflow-steps/step3-initial_workflow_script.sh` in a text editor.

## Determining what parts should become variables

In our example, the first workflow step is `fslroi`, called like this:

```
fslroi scans/OAS30001_MR_d3132/dwi1/sub-OAS30001_sess-d3132_run-01_dwi.nii.gz output/OAS30001_MR_d3132_nodif.nii.gz 0 1
```

This command is reliant on some specific information: 
- A directory name for where the scans are ("scans")
- A directory name for where the output needs to go ("output")
- A folder name within the scans folder that contains scans for this scan sesion, which I will refer to as the "session label" ("OAS30001_MR_d3132")
- A folder that is named for the scan ID or scan label used for our DTI scan ("dwi1")
- A file name for the DTI NIFTI file within the scan folder ("sub-OAS30001_sess-d3132_run-01_dwi.nii.gz")
- An output file name (OAS30001_MR_d3132_nodif.nii.gz)

All of this information is likely to change if you were to try to run your workflow on a different scan session or store your output data in a different place. In order to make your script portable, you will want to convert each of these changeable items into variables that can be set before you do each step.

## Create a variables section and start converting

Create a new section at the beginning of your script where your variables will be set. In our completed example for this step, `convert-workflow-steps/step4-script_with_hardcoded_inputs.sh`, we created a new section at the beginning for input variables and added comments describing what each input is. 

Go through each item in the first command and convert it to use a variable instead. For our example, we looked at the `scans` folder first. Someone else running this script might have their scans stored in a folder that's named something else. So to update it to be more generic, change the command to use a variable called `scans_dir` instead:
```
fslroi ${scans_dir}/OAS30001_MR_d3132/dwi1/sub-OAS30001_sess-d3132_run-01_dwi.nii.gz output/OAS30001_MR_d3132_nodif.nii.gz 0 1
```

and then at the new inputs section at the top of your script, add in what the `scans_dir` variable is set to in your workflow, and a comment about what that variable is for:
```
# Directory where the folders for each scan session are stored
scans_dir="scans"
```

In the next part, our command is looking for a specific session folder within the `scans` folder or `scans_dir`. In our example data organization, we will always expect that the `scans_dir` contains multiple folders, each named for one scan session, with each folder containing data for that scan session. The scan session we are looking for in the `scans_dir` is `OAS30001_MR_d3132`. This can be abstracted to a variable so a user can run this code on any scan session that has a folder in the `scans` directory. In our example we are calling this variable `session_label` and are expecting that the scan file folder and the FreeSurfer output folder will both share this name. We also want to use this session label in our output file names, so we can use that same variable in the output file name as well. 

The updated `fslroi` command will look like this:
```
fslroi ${scans_dir}/${session_label}/dwi1/sub-OAS30001_sess-d3132_run-01_dwi.nii.gz output/${session_label}_nodif.nii.gz 0 1
```

In the inputs section at the top of your script, add in what the `session_label` variable is set to in your workflow example, and a comment about what that variable is for.
```
# Label of the scan session that we are using scans and Freesurfer output from
session_label="OAS30001_MR_d3132"
```

In our example we are also going to replace the scan sub-folder "dwi1" with a variable called `scan_id` and the scan file name "sub-OAS30001_sess-d3132_run-01_dwi.nii.gz" with a variable called `dti_scan_filename`. The end result of the replacements will look like this:
```
fslroi ${scans_dir}/${session_label}/${dti_scan_id}/${dti_scan_filename} ${output_dir}/${session_label}_nodif.nii.gz 0 1
```

And our variable section at the beginning of the script should include two more variables like this:
```
dti_scan_id="dwi1"
dti_scan_filename="sub-OAS30001_sess-d3132_run-01_dwi.nii.gz"
```

Make these replacements for each command in your workflow, being careful to make sure you keep the naming consistent across each step. So if your script generates an output file that uses a variable, make sure the same naming with the variable is used the next time that file is used. If your script uses the same value in multiple places, such as if you are referring to the `scans_dir` multiple times, use the same variable name in all those places - so use `${scans_dir}` more than once.

Some steps might have options in them that aren't file, session, or scan information. For example, we have our initial version of our FSL `bet` command after we've updated it to use file location and session label variables:
```
bet ${output_dir}/${session_label}_nodif.nii.gz ${output_dir}/${session_label}_nodif_brain.nii.gz -f 0.25 -g 0 -m
```

For this command, we want to allow a user to change the input to `-f` to use a different fractional intensity threshold value or `-g` for a different gradient value. In order to do that we can create variables for these too:
```
bet ${output_dir}/${session_label}_nodif.nii.gz ${output_dir}/${session_label}_nodif_brain.nii.gz -f ${fi_threshold_value} -g ${gradient_value} -m
```

And add them to the top block of the script:
```
fi_threshold_value="0.25"
gradient_value="0"
```

Once you convert your script to use variables, save your edited file as `variables_workflow.sh`. remove things from your `output` folder from your last test run and then run the updated script to make sure it still works the same as before your updates:
```
./variables_workflow.sh
```

Make sure the results come out identical to your previous tests of your entire workflow.

## Continue with the tutorial

For this tutorial example, you updated `convert-workflow-steps/step3-initial_workflow_script.sh` file to a simple script called `variables_workflow.sh`. An example of our updated script file for this step is at `convert-workflow-steps/step4-script_with_hardcoded_inputs`. The next step of the tutorial will build on top of the contents of the step 4 file.

----
[documentation and examples on using variables in bash scripting]:https://linuxopsys.com/topics/assign-variable-bash